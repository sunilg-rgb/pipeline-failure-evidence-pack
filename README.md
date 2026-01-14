Pipeline Failure Evidence Pack (Next.js + n8n + Supabase)

This project automatically collects pipeline failure evidence and stores it into Supabase, then displays the results in a Next.js UI.

It demonstrates:

Triggering an n8n workflow via Webhook

Generating evidence_items + evidence_pack payload

Inserting into Supabase tables:

evidence_packs

evidence_items

Viewing the stored evidence in a simple UI table

✅ Features Implemented
1) n8n Workflow

Webhook trigger receives run_id + summary data

Code node generates evidence items

HTTP Request inserts into Supabase REST API

2) Supabase Database

Tables used:

evidence_packs

evidence_items

3) Next.js UI

Load Evidence button

Fetches from Supabase REST endpoint

Displays data in a table:

Created At

Run ID

Summary

Timeline Count

ID

🧱 Tech Stack

Next.js

Supabase (Postgres + REST API)

n8n Cloud

⚙️ Environment Variables

Create a file in root:

.env.local
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY

▶️ Run Locally

Install dependencies:

npm install


Start Next.js:

npm run dev


App runs on:

http://localhost:3000

🔗 Supabase REST API Used

Example:

GET  {SUPABASE_URL}/rest/v1/evidence_packs?select=*


Headers required:

apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <SUPABASE_ANON_KEY>
Content-Type: application/json

🧪 How to Test the Full Flow
Step 1: Trigger n8n Webhook

Use Postman / Hoppscotch / curl:

curl -X POST "YOUR_N8N_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "run_id": "b763ce30-3199-45b6-a311-3974a09f363a",
    "summary": "Pipeline failed due to database timeout"
  }'

Step 2: Confirm in Supabase

Go to Supabase Table Editor:

evidence_packs should contain the new record

evidence_items should contain related evidence rows

Step 3: View in Next.js UI

Click Load Evidence → data should appear in table.

🧾 n8n Workflow Export

The workflow export is included here:

n8n-workflow.json

Import it into n8n:

n8n → Workflows

Import from file

Select n8n-workflow.json

Update webhook URL + Supabase credentials

⚠️ Common Errors & Fixes
1) JSON parameter needs to be valid JSON

In n8n HTTP Request node → Body must be valid JSON like:

{
  "run_id": "{{$json.run_id}}",
  "summary": "{{$json.summary}}",
  "timeline": []
}

2) invalid input syntax for type uuid: "="

This happens when the value has extra characters like:

=b763ce30-...


Fix by trimming/cleaning before insert (use Edit Fields / Code node).

3) duplicate key value violates unique constraint evidence_packs_run_id_key

Means same run_id already exists in evidence_packs.
Solution:

Use a new run_id each time OR

Change to UPSERT logic later

🚀 Next Improvements (Planned)

Add UPSERT support (avoid duplicate run_id failures)

Insert evidence_items automatically linked to evidence_packs

Add filtering by run_id

Add details page for evidence pack

Add authentication + RLS policies

Production deployment via Coolify/Vercel

🎥 Demo Video

Demo video shows:

Supabase tables + schema

n8n workflow execution logs

Auto insert into Supabase

Next.js UI showing evidence table

https://www.loom.com/share/f86e3c2e54494163a350eb7714b18876
