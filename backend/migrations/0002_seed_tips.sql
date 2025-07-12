-- +goose Up

ALTER TABLE tips
    ADD CONSTRAINT unq_tips_category_message UNIQUE (category, message);

INSERT INTO tips (message, category)
VALUES ('Cold showers improve circulation.', 'en'),
       ('A cold shower can boost your mood and alertness.', 'en'),
       ('Start with lukewarm water, then switch to cold for 30 seconds.', 'en'),
       ('Cold exposure can help reduce muscle soreness.', 'en'),
       ('A daily cold shower may strengthen your immune system.', 'en'),
       ('Холодный душ улучшает кровообращение.', 'ru'),
       ('Холодный душ поднимает настроение и бодрит.', 'ru'),
       ('Начните с тёплой воды, затем 30 секунд холодной.', 'ru'),
       ('Холодовая терапия помогает снять мышечную боль.', 'ru'),
       ('Ежедневный холодный душ укрепляет иммунитет.', 'ru') ON CONFLICT (category, message) DO NOTHING;

-- +goose Down

DELETE
FROM tips
WHERE (category, message) IN (
                              ('en', 'Cold showers improve circulation.'),
                              ('en', 'A cold shower can boost your mood and alertness.'),
                              ('en', 'Start with lukewarm water, then switch to cold for 30 seconds.'),
                              ('en', 'A cold shower can help reduce muscle soreness.'),
                              ('en', 'A regular cold shower may strengthen your immune system.'),
                              ('ru', 'Холодный душ улучшает кровообращение.'),
                              ('ru', 'Холодный душ поднимает настроение и бодрит.'),
                              ('ru', 'Начните с тёплой воды, затем 30 секунд холодной.'),
                              ('ru', 'Холодный душ помогает снять мышечную боль.'),
                              ('ru', 'Регулярный холодный душ укрепляет иммунитет.')
    );

ALTER TABLE tips
DROP
CONSTRAINT IF EXISTS unq_tips_category_message;