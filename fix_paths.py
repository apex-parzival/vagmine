import os
import re
import shutil

p = r"e:\engineering\4th year\mirai int\vagmine"

html_files = [f for f in os.listdir(p) if f.endswith('.html')]

# Mapping from old to new names
name_map = {}

# 1. Rename HTML files
html_map = {
    'About – Vagmine Biz Solutions.html': 'about.html',
    'Contact – Vagmine Biz Solutions.html': 'contact.html',
    'Sectors – Vagmine Biz Solutions.html': 'sectors.html',
    'Services – Vagmine Biz Solutions.html': 'services.html',
    'Why Us_ – Vagmine Biz Solutions.html': 'why-us.html',
    'index.html': 'index.html'
}

# Add URL-encoded versions to the map, since hrefs might be url-encoded
# Actually, the python script will read the HTML content and replace occurrences.
# It's better to do substring replacement for the exact strings.

# 2. Rename folders
folder_map = {
    'About – Vagmine Biz Solutions_files': 'about_files',
    'Contact – Vagmine Biz Solutions_files': 'contact_files',
    'Sectors – Vagmine Biz Solutions_files': 'sectors_files',
    'Services – Vagmine Biz Solutions_files': 'services_files',
    'Vagmine Biz Solutions – Your trusted partner in IT hardware maintenance and services_files': 'index_files',
    'Why Us_ – Vagmine Biz Solutions_files': 'why_us_files'
}

# 3. Rename files in shots/
shots_dir = os.path.join(p, 'shots')
shots_map = {}
if os.path.isdir(shots_dir):
    for f in os.listdir(shots_dir):
        if not os.path.isfile(os.path.join(shots_dir, f)): continue
        new_name = f.lower().replace(' ', '_').replace('&', 'and').replace(',', '').replace('-', '_')
        if new_name != f:
            shots_map[f'shots/{f}'] = f'shots/{new_name}'
            # Also handle URL-encoded paths if they exist
            shots_map[f'shots/{f}'.replace(' ', '%20').replace('&', '&amp;')] = f'shots/{new_name}'
            os.rename(os.path.join(shots_dir, f), os.path.join(shots_dir, new_name))
            print(f"Renamed {f} to {new_name}")

# Now, rename the folders
for old, new in folder_map.items():
    old_path = os.path.join(p, old)
    new_path = os.path.join(p, new)
    if os.path.isdir(old_path) and old_path != new_path:
        os.rename(old_path, new_path)
        print(f"Renamed folder {old} to {new}")
        
# Read HTML files and replace everything
def url_encode(s):
    from urllib.parse import quote
    return quote(s)

all_replacements = {}
for old, new in html_map.items():
    if old != new:
        all_replacements[old] = new
        all_replacements[url_encode(old)] = new

for old, new in folder_map.items():
    if old != new:
        all_replacements[old] = new
        all_replacements[url_encode(old)] = new
        # Sometimes spaces are %20
        all_replacements[old.replace(' ', '%20')] = new

for old, new in shots_map.items():
    if old != new:
        all_replacements[old] = new

for old, new in all_replacements.items():
    print(f"Will replace: '{old}' -> '{new}'")

# Process each HTML file
for html_file in html_files:
    file_path = os.path.join(p, html_file)
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for old_str, new_str in sorted(all_replacements.items(), key=lambda x: len(x[0]), reverse=True):
        content = content.replace(old_str, new_str)
        # Handle cases where `&amp;` is used in HTML
        content = content.replace(old_str.replace('&', '&amp;'), new_str)
        
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

# Process CSS files in index_files
index_files_path = os.path.join(p, 'index_files')
if os.path.isdir(index_files_path):
    for root, dirs, files in os.walk(index_files_path):
        for file in files:
            if file.endswith('.css'):
                css_path = os.path.join(root, file)
                with open(css_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                for old_str, new_str in sorted(all_replacements.items(), key=lambda x: len(x[0]), reverse=True):
                    content = content.replace(old_str, new_str)
                    content = content.replace(old_str.replace(' ', '%20'), new_str)
                with open(css_path, 'w', encoding='utf-8') as f:
                    f.write(content)

# Finally, rename the HTML files themselves
for old, new in html_map.items():
    old_path = os.path.join(p, old)
    new_path = os.path.join(p, new)
    if os.path.exists(old_path) and old_path != new_path:
        os.rename(old_path, new_path)
        print(f"Renamed {old} to {new}")
        
print("Done fixing paths.")
