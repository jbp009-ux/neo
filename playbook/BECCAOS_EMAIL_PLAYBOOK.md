# BeccaOS Email Playbook

> **Account:** jose@beccaos.com (Google Workspace)
> **Operator:** Jose Brito, Founder | BeccaOS
> **Domain:** beccaos.com (Cloudflare DNS)
> **Last Updated:** 2026-02-13

---

## 1. Email Addresses (Send Mail As)

| Address | Use |
|---------|-----|
| `jose@beccaos.com` | Primary — personal/founder emails |
| `info@beccaos.com` | General inquiries, landing page contact forms |
| `support@beccaos.com` | Customer support tickets |

All three are configured in **Gmail > Settings > Accounts > Send mail as**.
Reply behavior: **Reply from the same address the message was sent to**.

### How to Add a New "Send Mail As" Address
1. Gmail > Settings (gear) > See all settings > **Accounts and Import**
2. "Send mail as" section > **Add another email address**
3. Enter name + new address (e.g., `sales@beccaos.com`)
4. Uncheck "Treat as an alias" only if it's a separate mailbox
5. Verify via confirmation email

---

## 2. Labels & Filters

| Label | Color | Filter Rule |
|-------|-------|-------------|
| **Info** | Red | `to:info@beccaos.com` → Apply label, skip inbox (optional) |
| **Support** | Blue | `to:support@beccaos.com` → Apply label |
| **BeccaOS** | Red | Manual / custom |
| **Affiliates** | Red | Manual / custom |
| **Services** | Green | Manual / custom |
| **Newsletters** | Green | Manual / custom |

### How to Create a New Label + Filter
1. Click the **search bar** > click **Show search options** (sliders icon)
2. In the "To" field, type the email address (e.g., `sales@beccaos.com`)
3. Click **Create filter**
4. Check **Apply the label** > Choose label > **New label** > type name > Create
5. Optionally check "Also apply filter to matching conversations"
6. Click **Create filter**

### How to Color-Code a Label
1. In the left sidebar, hover over the label name
2. Click the **three dots** that appear
3. Select **Label color** > pick your color

---

## 3. Email Authentication (DNS Records)

All records are in **Cloudflare DNS** for `beccaos.com`.

### MX Records (Google Mail Servers)
| Type | Name | Content | Priority |
|------|------|---------|----------|
| MX | @ | ASPMX.L.GOOGLE.COM | 1 |
| MX | @ | ALT1.ASPMX.L.GOOGLE.COM | 5 |
| MX | @ | ALT2.ASPMX.L.GOOGLE.COM | 5 |
| MX | @ | ALT3.ASPMX.L.GOOGLE.COM | 10 |
| MX | @ | ALT4.ASPMX.L.GOOGLE.COM | 10 |

### SPF Record
| Type | Name | Content |
|------|------|---------|
| TXT | @ | `v=spf1 include:_spf.google.com ~all` |

### DKIM Record
| Type | Name | Content |
|------|------|---------|
| TXT | google._domainkey | `v=DKIM1; k=rsa; p=MIIBIjANBgkq...` (2048-bit, generated in Admin Console) |

**Status:** DKIM activated in Google Admin Console > Apps > Gmail > Authenticate email

### DMARC Record
| Type | Name | Content |
|------|------|---------|
| TXT | _dmarc | `v=DMARC1; p=quarantine; rua=mailto:jose@beccaos.com` |

### How to Verify DNS Health
1. Go to: https://toolbox.googleapps.com/apps/checkmx/
2. Enter `beccaos.com`
3. All checks should pass (MX, SPF, DKIM, DMARC)

### How to Add DKIM for a New Domain
1. Google Admin Console > Apps > Google Workspace > Gmail > **Authenticate email**
2. Select domain > **Generate new record** (2048-bit, "google" prefix)
3. Copy the TXT record value
4. Add to Cloudflare: Type=TXT, Name=`google._domainkey`, Content=the key
5. Back in Admin Console > click **Start authentication**

---

## 4. Gmail Templates

### How to Enable Templates (if not already)
1. Gmail > Settings (gear) > See all settings > **Advanced**
2. Find "Templates" > select **Enable** > Save Changes

### All Templates (17 total)

#### Inbound — When People Contact You

**1. Info - Thanks for Reaching Out**
- **Use:** General inquiries to info@beccaos.com
- **Subject:** Thank You for Reaching Out to BeccaOS
- **Body:** Thanks for reaching out, we received your message, will review and respond within 24 hours, visit website for more info.

**2. Support - Request Acknowledgment**
- **Use:** Support tickets to support@beccaos.com
- **Subject:** We Received Your Support Request - BeccaOS
- **Body:** Thanks for contacting support, team is looking into it, expect response within 24 hours, include "URGENT" for urgent issues, can reply to add details.

**3. Partnership Inquiry - BeccaOS**
- **Use:** Partnership/collaboration proposals
- **Subject:** Partnership Inquiry - BeccaOS
- **Body:** Thanks for interest in partnering, asks for company overview + partnership type + timeline, team will follow up within 48 hours.

**4. Sonny - Product Inquiry**
- **Use:** Someone asks about Sonny
- **Subject:** Sonny - AI Ordering Assistant for Restaurants
- **Body:** Thanks for interest, explains what Sonny does (orders via chat/phone, 40+ languages, inventory, eliminates missed calls), link to sonny8.ai, offers demo.

**5. RIZEND - Product Inquiry**
- **Use:** Someone asks about RIZEND
- **Subject:** RIZEND - Fitness Coaching Platform
- **Body:** Thanks for interest, explains RIZEND (Coach Dashboard, Client Dashboard, communication, scaling), link to rizend.com, offers walkthrough. "Rise Together!"

---

#### Outbound — Cold Outreach (Detailed)

**6. Outreach - Restaurant (Sonny)**
- **Use:** Full feature pitch to restaurants
- **Subject:** Stop Missing Orders — Let AI Handle Your Phone & Online Orders
- **Placeholders:** `[Name]`, `[Restaurant Name]`
- **Body:** Detailed pitch with all Sonny features, free demo offer.

**7. Outreach - Coach (RIZEND)**
- **Use:** Full feature pitch to fitness coaches
- **Subject:** Grow Your Coaching Business — A Platform Built for Fitness Pros
- **Placeholders:** `[Name]`, `[Business/Brand Name]`
- **Body:** Detailed pitch with all RIZEND features, free walkthrough offer. "Rise Together!"

---

#### Outbound — With Demo Video Link (Use Once Videos Are Live)

**8. Outreach - Restaurant + Demo (Sonny)**
- **Subject:** Quick 2-Min Demo — See How AI Can Take Orders for Your Restaurant
- **Placeholders:** `[Name]`, `[Restaurant Name]`
- **Body:** Points to sonny8.ai demo video, bullet points of what they'll see, free trial offer.

**9. Outreach - Coach + Demo (RIZEND)**
- **Subject:** Quick Demo — A Coaching Platform That Actually Scales Your Business
- **Placeholders:** `[Name]`, `[Business/Brand Name]`
- **Body:** Points to rizend.com demo video, bullet points of what they'll see, free trial offer. "Rise Together!"

---

#### Outbound — Punchy v2 ("Quick Question" Hook)

**10. Sonny - Cold Outreach v2**
- **Subject:** Quick question about [Restaurant Name]
- **Placeholders:** `[First Name]`, `[Restaurant Name]`
- **Body:** "How much would you pay someone to answer every order request..." — short, punchy, personal sign-off "— Jose / Sonny | sonny8.ai"

**11. RIZEND - Cold Outreach v2**
- **Subject:** Quick question about your coaching business
- **Placeholders:** `[First Name]`, `[Business/Brand Name]`
- **Body:** "How much time do you spend each week on spreadsheets..." — short, punchy, personal sign-off "— Jose / RIZEND | rizend.com"

---

#### Outbound — Punchy v3 ("I Built This For One Reason")

**12. Sonny - Cold Outreach v3**
- **Subject:** Your team handles hospitality, Sonny handles the orders
- **Placeholders:** `[First Name]`
- **Body:** "I built Sonny for one reason: restaurants are busy, short-staffed, and losing orders..." — bullet points (takes orders, alternatives, combos, kitchen-ready), "— Jose / Sonny | sonny8.ai"

**13. RIZEND - Cold Outreach v3**
- **Subject:** You coach, RIZEND handles the rest
- **Placeholders:** `[First Name]`
- **Body:** "I built RIZEND for one reason: fitness coaches are talented, overbooked, and losing clients..." — bullet points (Coach Dashboard, Client portal, communication, scales), "— Jose / RIZEND | rizend.com"

---

#### Outbound — Follow Up (No Reply After 3-5 Days)

**14. Sonny - Follow Up**
- **Subject:** One quick thought
- **Placeholders:** `[First Name]`
- **Body:** "If one missed order per day costs your store real revenue, what would 24/7 order coverage be worth to you?" — offers demo video or live walkthrough, "— Jose / Sonny | sonny8.ai"

**15. RIZEND - Follow Up**
- **Subject:** One quick thought
- **Placeholders:** `[First Name]`
- **Body:** "If losing one client per month to disorganization costs your business real revenue, what would a system that keeps every client engaged be worth to you?" — offers demo video or live walkthrough, "— Jose / RIZEND | rizend.com"

---

#### Outbound — Video Thumbnail Email (With Canva Image)

**16. Sonny - Video Thumbnail Email**
- **Subject:** See how Sonny takes orders for your restaurant (30 sec)
- **Placeholders:** `[First Name]`, `▶ [INSERT YOUR CANVA THUMBNAIL IMAGE HERE — link it to sonny8.ai]`
- **Body:** "I built Sonny to help restaurants stop losing orders..." — placeholder for thumbnail image, bullet points of what they'll see, "Worth a look? — Jose"

**17. RIZEND - Video Thumbnail Email**
- **Subject:** See how RIZEND runs your coaching business (30 sec)
- **Placeholders:** `[First Name]`, `▶ [INSERT YOUR CANVA THUMBNAIL IMAGE HERE — link it to rizend.com]`
- **Body:** "I built RIZEND to help fitness coaches stop drowning in admin..." — placeholder for thumbnail image, bullet points of what they'll see, "Worth a look? — Jose"

---

### How to Use a Template
1. Click **Compose** (or Reply)
2. Click the **three dots** (More options) in the bottom toolbar
3. Click **Templates**
4. Under "INSERT TEMPLATE" — click the template name
5. Replace all `[bracketed placeholders]` with real info
6. Hit **Send**

### How to Create a New Template
1. Click **Compose**
2. Write your subject and body
3. Click **three dots** > **Templates** > **Save draft as template** > **Save as new template**
4. Name it and click **Save**

### How to Update an Existing Template
1. Click **Compose**
2. Load the template (three dots > Templates > click template name)
3. Make your changes
4. Click **three dots** > **Templates** > **Save draft as template** > **Overwrite** > click the template name
5. Confirm overwrite

### How to Add the Canva Video Thumbnail
1. Record your demo video, upload to sonny8.ai or rizend.com
2. In **Canva**: screenshot a good frame from the video > add a big play button overlay > export as PNG
3. In **Gmail**: Compose > load the thumbnail template
4. Delete the `▶ [INSERT YOUR CANVA...]` placeholder text
5. Click the **Insert photo** icon (mountain icon in toolbar) > upload your Canva thumbnail
6. Click the image > click the **Link** icon > paste `https://sonny8.ai` or `https://rizend.com`
7. Save: three dots > Templates > Save draft as template > **Overwrite** > select the template
8. Now every time you use this template, the clickable thumbnail is built in

---

## 5. Recommended Email Sequence

### For Restaurants (Sonny)
| Day | Action | Template |
|-----|--------|----------|
| Day 1 | First touch — pick v2 or v3 | Sonny - Cold Outreach v2 or v3 |
| Day 4 | No reply? Follow up | Sonny - Follow Up |
| Day 8 | Still nothing? Send the video | Sonny - Video Thumbnail Email |

### For Coaches (RIZEND)
| Day | Action | Template |
|-----|--------|----------|
| Day 1 | First touch — pick v2 or v3 | RIZEND - Cold Outreach v2 or v3 |
| Day 4 | No reply? Follow up | RIZEND - Follow Up |
| Day 8 | Still nothing? Send the video | RIZEND - Video Thumbnail Email |

### When Someone Replies
- Interested in Sonny → use **Sonny - Product Inquiry** or schedule demo directly
- Interested in RIZEND → use **RIZEND - Product Inquiry** or schedule walkthrough
- Partnership question → use **Partnership Inquiry - BeccaOS**
- Support issue → use **Support - Request Acknowledgment**
- General question → use **Info - Thanks for Reaching Out**

---

## 6. Signature

All templates include the BeccaOS signature:
```
--
[BeccaOS Logo]

Jose Brito
Founder | BeccaOS
jose@beccaos.com
```

This is set as the default signature in Gmail > Settings > General > Signature.

---

## 7. Quick Reference

| Task | Where |
|------|-------|
| Add new "Send mail as" | Gmail > Settings > Accounts > Send mail as |
| Create label + filter | Search bar > Show search options > To field > Create filter |
| Check DNS health | https://toolbox.googleapps.com/apps/checkmx/ |
| DKIM settings | Admin Console > Apps > Gmail > Authenticate email |
| Manage templates | Compose > three dots > Templates |
| Cloudflare DNS | https://dash.cloudflare.com > beccaos.com > DNS |

---

*This playbook was created during the BeccaOS Gmail setup session on 2026-02-13.*
