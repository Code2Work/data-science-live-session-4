# Pearson mı, Spearman mı?

**Code2Work Data Science — Canlı Ders**
📅 5 Kasım 2026
🎥 Ders kaydı: [vimeo.com/1243813861](https://vimeo.com/1243813861)

---

## Bu Derste Neler İşledik?

- Dersteki örneğe dönüş: veri kusursuz doğrusal olunca iki yöntem neden aynı sonucu veriyor
- **Pearson** = "düz çizgi mi?" (cetvel) · **Spearman** = "aynı yöne mi gidiyor?" (sıra)
- Farkın görüldüğü 3 durum:
  - **Eğri ama hep artan** ilişki (her ay 2 katına çıkan takipçi)
  - **Aykırı değer** (tek hatalı kayıt Pearson'ı ters çeviriyor, Spearman dayanıklı)
  - **Sıralı veri** (1-5 anket puanı)
- Hangi durumda hangisi: karar tablosu
- Ek (derste görmediğimiz): `.rank()` ile Spearman = sıralara uygulanmış Pearson

> **Akılda kalacak cümle:** Pearson "düz çizgi mi?" diye sorar, Spearman "aynı yöne mi gidiyor?" diye.

---

## Dosyalar

| Dosya | İçerik |
|-------|--------|
| `sunum.html` | Kavram girişi (tarayıcıda aç, ← → ile gez) |
| `pearson_spearman.ipynb` | Dersteki tüm kodlar ve grafikler |

---

## Nasıl Çalıştırılır?

Notebook veri dosyası istemez, veriler içinde üretiliyor.

```bash
pip install pandas matplotlib jupyter
jupyter notebook pearson_spearman.ipynb
```
