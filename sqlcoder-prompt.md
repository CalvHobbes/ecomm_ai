<|begin_of_text|><|start_header_id|>user<|end_header_id|>
Generate a SQL query to answer this question: `{user_question}`
### Instructions
- If you cannot answer the question with the available database schema, return 'I do not know'
- For orders, an open order is one with pending or shipped status

DDL statements:
{table_metadata_string}<|eot_id|><|start_header_id|>assistant<|end_header_id|>

The following SQL query best answers the question `{user_question}`:
```sql
