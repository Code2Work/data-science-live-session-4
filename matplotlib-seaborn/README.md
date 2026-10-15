# Matplotlib ve Seaborn ile Görselleştirme

**Code2Work Data Science — Canlı Ders**
📅 4 Haziran 2026
🎥 Ders kaydı: [vimeo.com/1198503184](https://vimeo.com/1198503184)

---

## Bu Derste Neler İşledik?

### Bölüm 1 — Matplotlib Detaylandırma

- **3 aşamalı dönüşüm**: ham grafik → okunaklı → sunum kalitesi
  - `title`, `color`, `xticks` rotation, `figsize`, `barh`, spines, bar üstüne sayı yazma
- **Renk vermenin 4 yolu**: hex (`"#71D000"`), isim (`"steelblue"`), RGB tuple, liste (her bar ayrı renk)
- **`annotate()`** — grafikte önemli bir noktayı ok + yazıyla işaretleme
- **`plt.subplots()`** — birden fazla grafiği yan yana / alt alta çizme
- **`ax.twinx()`** — aynı x ekseninde iki farklı y ekseni

### Bölüm 2 — Seaborn

- Aynı bar grafiği: `sns` vs `plt`
- **`hue=`** — tek satırla gruplama, renk ve legend otomatik ⭐
- **Heatmap** parametreleri (`annot`, `fmt`, `cmap`)
- **Renk paletleri**: sürekli (viridis), kategorik (Set2), diverging (coolwarm)

---

## Dosyalar

| Dosya | İçerik |
|-------|--------|
| `graph_examples.ipynb` | Dersteki tüm kodlar — Jupyter'da aç, hücreleri sırayla çalıştır |
| `data/contestants.csv` | Eurovision yarışmacı verisi |
| `data/votes.csv` | Eurovision oy verisi |

---

## Nasıl Çalıştırılır?

Notebook veritabanı istemez, CSV dosyalarını okur. Notebook ile `data` klasörü aynı yerde olmalı.

```bash
pip install pandas matplotlib seaborn jupyter
jupyter notebook graph_examples.ipynb
```

---

## Veri Seti

Eurovision Song Contest verisi. Kaynak: [Spijkervet/eurovision-dataset](https://github.com/Spijkervet/eurovision-dataset)
