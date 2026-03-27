# Vagmine Subdomain Deployment Guide (Cross-Account)

This guide provides a safe, step-by-step process to link your client's domain (`zoochimp.com`) to your personal AWS Amplify account. By using CNAME DNS records, **you completely avoid transferring domain ownership**, and you **guarantee that the client's main domain (`www.zoochimp.com`) remains 100% untouched and unaffected.**

## Phase 1: Obtaining DNS Records from Your AWS Account

Since your client's code is hosted on *your* AWS Amplify account, we first need to tell your AWS account what subdomain you want to use. AWS will then give us "proof of ownership" records to put into the client's DNS.

1.  **Log in to YOUR AWS Account:** Open the AWS Management Console and navigate to **AWS Amplify**.
2.  **Select Your App:** Click on the Vagmine app you previously deployed.
3.  **Domain Management:** In the left sidebar, under "App settings", click on **Domain management**.
4.  **Add Domain:** Click the **Add domain** button.
5.  **Configure Subdomain (CRITICAL STEP):**
    *   In the "Domain" field, type the client's domain: `zoochimp.com` and click "Configure domain".
    *   **CRITICAL:** AWS will attempt to set up the root domain (`zoochimp.com`) by default. **You MUST click "Exclude root"** or manually remove the mapping for the root domain.
    *   Click **Add subdomain**.
    *   Enter the prefix you want (e.g., `vagmine`). The target should be your `main` branch.
    *   The setup should clearly show that *only* `https://vagmine.zoochimp.com` is mapped to your `main` branch.
6.  **Save and Wait for SSL:** Click **Save and configure**. AWS will begin creating a free SSL certificate.
7.  **Get DNS Records:** Once the SSL setup process begins, click **View DNS records**. AWS will provide you with **two** sets of records you need to copy:
    *   **SSL Validation Record:** A CNAME record to prove you are authorized to use this subdomain (e.g., Name: `_xyz.vagmine`, Value: `_abc.acm-validations.aws.`).
    *   **App Domain Record:** A CNAME record to route the traffic to your Amplify app (e.g., Name: `vagmine`, Value: `xxxxxx.cloudfront.net`).
    *   *Keep this AWS tab open.*

---

## Phase 2: Adding Records in the Client's Zoochimp Dashboard

Now we will add the CNAME records provided by your AWS account into your client's Zoochimp domain manager. **This will only affect the specific subdomain you create (`vagmine.zoochimp.com`) and will not touch their main website.**

1.  **Log in to the Client's Zoochimp Portal:**
    *   Go to: `https://www.zoochimp.com/` (or the client's specific login page).
    *   **Username:** `lkshvnk@gmail.com`
    *   **Password:** `V@gmine!8055`
2.  **Navigate to DNS Management:** Once logged in, look for a section named **"DNS Management"**, **"DNS Zone Editor"**, or **"Manage Domains"** for `zoochimp.com`.
3.  **Add the SSL Validation Record (CNAME):**
    *   Click **Add Record**.
    *   **Type:** Select `CNAME`.
    *   **Name/Host:** Paste the "Name" provided by AWS (e.g., `_xyz.vagmine`). *Note: Some panels automatically add `.zoochimp.com` to the end, so just enter the first part.*
    *   **Value/Target:** Paste the "Value" provided by AWS (ends in `acm-validations.aws.`).
    *   **TTL:** Leave as default (or select 3600/1 Hour).
    *   Click **Save**.
4.  **Add the App Routing Record (CNAME):**
    *   Click **Add Record** again.
    *   **Type:** Select `CNAME`.
    *   **Name/Host:** Enter your exact subdomain prefix (e.g., `vagmine`).
    *   **Value/Target:** Paste the CloudFront URL provided by AWS (e.g., `xxxxxx.cloudfront.net`).
    *   **TTL:** Leave as default.
    *   Click **Save**.

---

## Phase 3: Final Verification

1.  **Wait for Propagation:** DNS changes can take anywhere from 5 minutes to a few hours depending on the client's DNS provider. 
2.  **Check Your AWS Amplify:** Go back to your open AWS Amplify tab. 
    *   The status should automatically transition from "Pending verification" to "Verified" to "Available".
3.  **Test the Link:** Once AWS says "Available", open a new incognito window and type your new URL (e.g., `https://vagmine.zoochimp.com`).
4.  **Main Site Check (Client Assurance):** Visit `https://www.zoochimp.com` to confirm it is still running exactly as it was before, completely unaffected by the new subdomain pointing to your AWS account.
