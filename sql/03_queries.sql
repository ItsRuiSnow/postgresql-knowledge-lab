-- A. Inspect stored documents.
SELECT id, title, content
FROM documents
ORDER BY id;

-- B. Which documents have the '数据库' tag?
SELECT d.id, d.title
FROM documents AS d
JOIN document_tags AS dt
    ON d.id = dt.document_id
JOIN tags AS t
    ON dt.tag_id = t.id
WHERE t.name = '数据库'
ORDER BY d.id;

-- C. How many documents use each tag?
SELECT t.name, COUNT(dt.document_id) AS document_count
FROM tags AS t
LEFT JOIN document_tags AS dt
    ON t.id = dt.tag_id
GROUP BY t.id, t.name
ORDER BY t.id;
