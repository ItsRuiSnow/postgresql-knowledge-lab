-- Known fixture data for Lesson 01; run once after 01_schema.sql.
BEGIN;

INSERT INTO documents (id, title, content)
VALUES
    (1, 'PostgreSQL 入门', '学习关系型数据库'),
    (2, 'SQL JOIN 笔记', '学习多表关联查询'),
    (3, 'AI Agent 设计', '学习 AI Agent 架构');

INSERT INTO tags (id, name)
VALUES
    (10, '数据库'),
    (20, 'SQL'),
    (30, 'AI');

INSERT INTO document_tags (document_id, tag_id)
VALUES
    (1, 10),
    (2, 10),
    (2, 20),
    (3, 30);

COMMIT;
