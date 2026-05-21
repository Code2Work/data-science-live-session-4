# Subquery, WITH, VIEW + Python f-string

**Code2Work Data Science — Canlı Ders**
📅 14 Mayıs 2026
🎥 Ders kaydı: [vimeo.com/1194464200](https://vimeo.com/1194464200)

---

## Bu Derste Neler İşledik?

### Bölüm 1 — SQL Derinleşmesi

- **Subquery** (sorgu içinde sorgu)
  - Tek sayı dönen subquery
  - Tek değer dönen subquery
  - Liste dönen subquery (`IN` / `NOT IN`)
- **WITH (CTE)** — isimli, geçici subquery
  - Subquery'yi WITH ile yeniden yazma
  - Çok adımlı analiz (en güçlü kullanım)
- **VIEW** — kalıcı, isimli subquery
  - `CREATE OR REPLACE VIEW ... AS ...`

### Bölüm 2 — Python String Formatting

- `%` formatting (eski)
- `.format()` (orta)
- **f-string** (modern) ⭐
- Format spec'leri:
  - `{x:.2f}` — ondalık basamak
  - `{x:,}` — binlik ayraç
  - `{x:.1%}` — yüzde
  - `{x:>10}`, `{x:<10}` — hizalama

---

## Dosyalar

| Dosya | İçerik |
|-------|--------|
| `sunum.html` | Ders sunumu (30 slayt, ok tuşlarıyla gez) |
| `queries.sql` | SQL örnekleri — pgAdmin'de çalıştır |
| `python_examples.ipynb` | Python notebook — Jupyter'da aç |

---

## Veri Seti

Eurovision Song Contest verisi (1956-2023). PostgreSQL `eurovision` schema'sı altında.

Veri yüklemediysen [Spijkervet/eurovision-dataset](https://github.com/Spijkervet/eurovision-dataset) deposundan indirebilirsin.

---

## Ev Ödevi

- 🟢 **Yeni başlayan**: Bir ülke seç, kendi VIEW'ını oluştur. Sonra ortalamasını + en yükseğini hesapla.
- 🟠 **Orta**: WITH ile: "Her yılın en iyi 3 ülkesi" → "en sık ilk 3'e giren ülke kim?"
- 🟣 **İleri**: Eurovision'da en iyi 10 ülkeyi **f-string tablosu** ile yazdır (yüzde dahil).
