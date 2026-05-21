-- ═══════════════════════════════════════════════════════════════════════
-- DS Canlı Ders — 14 Mayıs 2026
-- Subquery, WITH, VIEW — Eurovision verisiyle
--
-- Sunumla birlikte pgAdmin'de canlı çalıştırılacak.
-- Slayt geldiğinde altındaki sorguyu kopyala-yapıştır.
-- ═══════════════════════════════════════════════════════════════════════


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- BÖLÜM 1 — SUBQUERY (sorgu içinde sorgu)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


-- ─── 📌 ÖRNEK 1 — Tek sayı dönen subquery ──────────────────────────────

-- Eurovision ortalamasının ÜSTÜNDE puan alan tüm yarışmalar
SELECT year, to_country, performer, points_final
FROM eurovision.contestants
WHERE points_final > (
    SELECT AVG(points_final)
    FROM eurovision.contestants
)
ORDER BY points_final DESC
LIMIT 10;

-- İçerideki sorgu önce çalışır → tek bir sayı döner (≈ 88)
-- Dış sorgu o sayıyı kullanır
-- Mesaj: "Subquery = sorgu içinde sorgu, parantez içinde yazılır"



-- ─── 📌 ÖRNEK 2 — Tek satır dönen subquery ─────────────────────────────

-- En çok kazanan ülkenin TÜM yarışmaları
SELECT year, performer, place_final, points_final
FROM eurovision.contestants
WHERE to_country = (
    SELECT to_country
    FROM eurovision.contestants
    WHERE place_final = 1
    GROUP BY to_country
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
ORDER BY place_final
LIMIT 10;

-- İçerideki sorgu: "en çok 1. olan ülke kim?" → 'Ireland' veya 'Sweden'
-- Dış sorgu: o ülkenin tüm satırları
-- Mesaj: "İki ayrı sorgu yazmaya gerek yok — tek seferde"



-- ─── 📌 ÖRNEK 3 — Liste dönen subquery (IN) ────────────────────────────

-- Hiç birinci olamamış ülkelerin tüm yarışmaları
SELECT DISTINCT to_country, COUNT(*) AS katilim
FROM eurovision.contestants
WHERE to_country NOT IN (
    SELECT DISTINCT to_country
    FROM eurovision.contestants
    WHERE place_final = 1
)
  AND place_final IS NOT NULL
GROUP BY to_country
ORDER BY katilim DESC
LIMIT 10;

-- İçerideki sorgu: "Hiç kazananlar listesi" → ('Ireland', 'Sweden', ...)
-- Dış sorgu: bu listede OLMAYAN ülkeleri filtreler
-- Mesaj: "IN / NOT IN ile liste dönen subquery"



-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- BÖLÜM 2 — WITH (CTE = Common Table Expression)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


-- ─── 📌 ÖRNEK 4 — Aynı subquery'yi WITH ile yazalım ────────────────────

-- ÖRNEK 1'in tıpkı aynısı, WITH ile
WITH genel_ortalama AS (
    SELECT AVG(points_final) AS ort
    FROM eurovision.contestants
)
SELECT year, to_country, performer, points_final
FROM eurovision.contestants, genel_ortalama
WHERE points_final > genel_ortalama.ort
ORDER BY points_final DESC
LIMIT 10;

-- Mesaj: "WITH = subquery'ye İSİM ver, dışarıda kullan. Okunaklı."



-- ─── 📌 ÖRNEK 5 — Çok adımlı analiz: WITH'in asıl gücü ─────────────────

-- Her ülkenin ortalama puanı + Türkiye'nin bu ortalamanın üstünde kaldığı yıllar
WITH ulke_ortalama AS (
    SELECT to_country, AVG(points_final) AS ort
    FROM eurovision.contestants
    WHERE points_final IS NOT NULL
    GROUP BY to_country
)
SELECT c.year, c.performer, c.points_final,
       ROUND(u.ort::numeric, 1) AS turkiye_ortalama
FROM eurovision.contestants c
JOIN ulke_ortalama u ON c.to_country = u.to_country
WHERE c.to_country = 'Turkey'
  AND c.points_final > u.ort
ORDER BY c.points_final DESC;

-- Beklenen: 2004 Athena (195), 2009 Hadise (177), 2010 maNga (170), 2003 Sertab (167)...
-- Mesaj: "İki adımlı işi tek sorguda — WITH okumayı kolaylaştırır"



-- ─── 📌 ÖRNEK 6 — Birden fazla WITH (zincir) ───────────────────────────

-- 1) Her ülkenin ortalaması  →  2) Genel ortalamadan iyi ülkeler  →  sırala
WITH ulke_ortalama AS (
    SELECT to_country, AVG(points_final) AS ort
    FROM eurovision.contestants
    WHERE points_final IS NOT NULL
    GROUP BY to_country
),
genel_ortalama AS (
    SELECT AVG(ort) AS genel FROM ulke_ortalama
)
SELECT u.to_country, ROUND(u.ort::numeric, 1) AS ulke_ort
FROM ulke_ortalama u, genel_ortalama g
WHERE u.ort > g.genel
ORDER BY u.ort DESC
LIMIT 10;

-- Mesaj: "WITH ile zincir adım kurabilirsin. Her adım önceki üzerine inşa edilir."



-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- BÖLÜM 3 — VIEW (kısa değiniş, ~5 dk)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


-- ─── 📌 ÖRNEK 7 — VIEW oluştur ─────────────────────────────────────────

-- Türkiye verisini her seferinde yeniden filtrelemek yerine VIEW kuralım
CREATE OR REPLACE VIEW eurovision.turkiye_yarismalari AS
SELECT year, performer, song, place_final, points_final
FROM eurovision.contestants
WHERE to_country = 'Turkey' AND place_final IS NOT NULL;

-- Şimdi sanki bir tablo gibi kullanabiliriz
SELECT * FROM eurovision.turkiye_yarismalari ORDER BY place_final LIMIT 5;

-- VIEW'a karşı sorgu atabiliriz
SELECT AVG(points_final) FROM eurovision.turkiye_yarismalari;


-- Mesaj:
-- WITH = tek seferlik, isim verilmiş subquery
-- VIEW = KALICI, isim verilmiş subquery (DB'de saklı kalır)
-- Subquery = isim yok, sorgu içinde anonim


-- VIEW'ı silmek için:
-- DROP VIEW eurovision.turkiye_yarismalari;



-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- HANGİ NE ZAMAN?
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- ┌─────────────┬─────────────────────────────────┬─────────────────────┐
-- │ Subquery    │ Tek seferlik, küçük sorgular    │ Anonim, parantez içi│
-- │ WITH (CTE)  │ Çok adımlı, okunabilir analiz   │ Sorgu sonu yok olur │
-- │ VIEW        │ Tekrar tekrar kullanılacak      │ DB'de KALICI        │
-- └─────────────┴─────────────────────────────────┴─────────────────────┘



-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- EV ÖDEVİ
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- 🟢 Yeni başlayan: Örnek 1'i farklı bir karşılaştırmayla dene
--    Örn: "İsveç'in ortalamasından daha çok puan alan yarışmalar"

-- 🟠 Orta: WITH ile şu soruyu cevapla:
--    "Her yılın en iyi 3 ülkesini bul, sonra hangi ülke en sık ilk 3'e girdi?"

-- 🟣 İleri: WITH zinciri ile:
--    1) Her ülkenin toplam puanı
--    2) Bunların ortalaması
--    3) Ortalamanın üstündeki ülkelerin oranı
