class AppTexts {
  static String get(String key, String lang) {
    if (_localizedValues.containsKey(key)) {
      return _localizedValues[key]?[lang] ?? key;
    }
    return "MISSING: $key";
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    // --- MEVCUT GENEL METİNLER (DEĞİŞTİRİLMEDİ) ---
    'play': {'TR': 'OYNA', 'EN': 'PLAY'},
    'buy': {'TR': 'SATIN AL', 'EN': 'BUY'},
    'pause_msg': {'TR': 'Oyun molası veriliyor...', 'EN': 'Game paused...'},
    'start_link': {'TR': 'BAĞLANTIYI BAŞLAT', 'EN': 'INITIATE LINK'},
    'mission_select': {'TR': 'GÖREV SEÇİMİ (16 FAZ)', 'EN': 'MISSION SELECT'},
    'zone_1_title': {'TR': 'BÖLGE 1: KUTUPLAR', 'EN': 'ZONE 1: POLES'},
    'zone_2_title': {'TR': 'BÖLGE 2: OKYANUS', 'EN': 'ZONE 2: OCEAN'},
    'zone_3_title': {'TR': 'BÖLGE 3: UZAY', 'EN': 'ZONE 3: SPACE'},
    'zone_4_title': {'TR': 'BÖLGE 4: NEXUS', 'EN': 'ZONE 4: NEXUS'},
    'locked_msg': {'TR': 'Önceki seviyeyi tamamla!', 'EN': 'Complete previous level!'},
    'check': {'TR': 'KONTROL ET', 'EN': 'CHECK'},
    'retry': {'TR': 'HATALI! Tekrar Dene', 'EN': 'ERROR! Retry'},
    'success': {'TR': 'BAŞARILI', 'EN': 'SUCCESS'},
    'continue': {'TR': 'DEVAM ET', 'EN': 'CONTINUE'},
    'stage_prefix': {'TR': 'AŞAMA', 'EN': 'STAGE'},

    // --- YENİ EKLENEN/GÜNCELLENEN HİKAYE METİNLERİ ---
    
    // GİRİŞ HİKAYESİ (YENİ SENARYO)
    'intro_story': {
      'TR': "> GÜVENLİ HAT KURULUYOR...\n> YIL: 2084\n\nKutuplardaki araştırma istasyonumuzdan gelen sinyal kesildi.\nSon veriler, buzun altında devasa bir enerji dalgalanması gösteriyor.\n\nBu bir kurtarma görevi değil. Bu bir keşif görevi.\n\nBuzun altındaki 'Şey' uyanıyor.\nOkyanusun derinliklerinden fısıltılar geliyor.\n\nGörevin: İstasyonu aç. Yaratığı analiz et. Zihnini koru.\n\n> SİSTEM HAZIR.",
      'EN': "> SECURE LINE ESTABLISHED...\n> YEAR: 2084\n\nSignal lost from the Polar Research Station.\nLast data shows massive energy fluctuations beneath the ice.\n\nThis is not a rescue mission. This is a discovery mission.\n\nThe 'Thing' beneath the ice is waking up.\nWhispers are rising from the ocean depths.\n\nYour mission: Power the station. Analyze the creature. Protect your mind.\n\n> SYSTEM READY."
    },

    // FİZİKİ KART SİSTEMİ (EKLENDİ)
    'card_alert_title': {'TR': 'FİZİKİ KART GEREKLİ', 'EN': 'PHYSICAL CARD REQUIRED'},
    'card_alert_desc': {
      'TR': 'Oyuna devam etmek için gerçek dünyadaki bilgi kartını kullanmalısın.',
      'EN': 'You must use the physical info card in the real world to proceed.'
    },
    'card_btn_read': {'TR': 'KARTI OKUDUM', 'EN': 'I HAVE READ THE CARD'},
    'card_wrong': {'TR': 'Yanlış Bilgi! Kartı tekrar oku.', 'EN': 'Wrong Info! Read card again.'},

    // KART 1 (İstasyon)
    'c1_name': {'TR': 'KART #1: KARIN GÜCÜ', 'EN': 'CARD #1: POWER OF SNOW'},
    'c1_q': {'TR': 'Fırtına çıktı! Donmak üzeresin. Karttaki bilgiye göre ne yapmalısın?', 'EN': 'Storm hits! Freezing. Based on the card, what should you do?'},
    'c1_a': {'TR': 'Koşarak ısın', 'EN': 'Run to warm up'},
    'c1_b': {'TR': 'Kar çukuru kaz', 'EN': 'Dig snow hole'},

    // KART 2 (Buzul/Yaratık)
    'c2_name': {'TR': 'KART #2: BEYAZ KARANLIK', 'EN': 'CARD #2: WHITEOUT'},
    'c2_q': {'TR': 'Her yer bembeyaz (Whiteout). Yaratığın izini sürmek için neye güvenmelisin?', 'EN': 'Whiteout conditions. How to track the creature?'},
    'c2_a': {'TR': 'Siyah obje at', 'EN': 'Throw dark object'},
    'c2_b': {'TR': 'Gözlerine güven', 'EN': 'Trust your eyes'},

    // KART 3 (Okyanus)
    'c3_name': {'TR': 'KART #3: AVCI BARINAĞI', 'EN': 'CARD #3: HUNTER SHELTER'},
    'c3_q': {'TR': 'Eski bir et deposu buldun. Çok açsın. Hangi eti YEMEMELİSİN?', 'EN': 'Found old meat stash. Starving. Which meat MUST you avoid?'},
    'c3_a': {'TR': 'Kas Eti', 'EN': 'Muscle Meat'},
    'c3_b': {'TR': 'Ayı Ciğeri', 'EN': 'Bear Liver'},

    // KART 4 (Zihin)
    'c4_name': {'TR': 'KART #4: ALBEDO ETKİSİ', 'EN': 'CARD #4: ALBEDO EFFECT'},
    'c4_q': {'TR': 'Zemin çöküyor. Karşıya geçmek için hangi zemine basmalısın?', 'EN': 'Ground collapsing. Which surface is safer to step on?'},
    'c4_a': {'TR': 'Koyu Mavi Buz', 'EN': 'Dark Blue Ice'},
    'c4_b': {'TR': 'Beyaz Karlı Buz', 'EN': 'White Snowy Ice'},

    // --- LEVEL 1: İSTASYON (HİKAYE GÜNCELLENDİ) ---
    'l1_title': {'TR': 'SEVİYE 1: ISI DENGESİ', 'EN': 'LEVEL 1: HEAT BALANCE'},
    'l1_s1_story': {'TR': "İstasyon Kapısı Kilitli (-60°C).\nEnerji akışını dengele (Net: 0) ve içeri gir.", 'EN': "Station Door Locked (-60°C).\nBalance energy flow (Net: 0) to enter."},
    'l1_s1_task': {'TR': 'SORU İŞARETİ (?) KAÇ OLMALI?', 'EN': 'VALUE OF (?)?'},
    'l1_s2_story': {'TR': "Sesli doğrulama isteniyor.\nBu bilmecenin cevabı nedir?", 'EN': "Voice auth required.\nWhat is the answer?"},
    'l1_s2_riddle': {'TR': "\"Kanadım yok uçarım. Gözüm yok ağlarım.\nKaranlık beni takip eder.\nBen neyim?\"", 'EN': "\"I fly without wings. I cry without eyes.\nDarkness follows me.\nWhat am I?\""},
    'l1_s2_opt1': {'TR': 'RÜZGAR', 'EN': 'WIND'},
    'l1_s2_opt2': {'TR': 'BULUT', 'EN': 'CLOUD'},
    'l1_s2_opt3': {'TR': 'UÇAK', 'EN': 'PLANE'},
    'l1_s3_story': {'TR': "Basınç arttı! Valfleri ASAL SAYI sırasına göre aç.", 'EN': "Pressure rising! Open valves in PRIME NUMBER order."},
    'l1_reward': {'TR': 'İstasyon Aktif.\nSensörler Buzun Altında Anomali Tespit Etti.', 'EN': 'Station Online.\nSensors Detected Anomaly Beneath Ice.'},

    // --- LEVEL 2: BUZULLAR (HİKAYE GÜNCELLENDİ - YARATIK) ---
    'l2_title': {'TR': 'SEVİYE 2: DERİN BUZ', 'EN': 'LEVEL 2: DEEP ICE'},
    'l2_s1_story': {'TR': "Buzulun içindeki katmanları analiz et.\nYENİDEN ESKİYE doğru sırala.", 'EN': "Analyze layers within the glacier.\nOrder from NEW to OLD."},
    'l2_optA': {'TR': 'A: Sanayi Devrimi', 'EN': 'A: Industrial Rev.'},
    'l2_optB': {'TR': 'B: Toba Volkanı', 'EN': 'B: Toba Volcano'},
    'l2_optC': {'TR': 'C: Buzul Çağı', 'EN': 'C: Ice Age'},
    'l2_optD': {'TR': 'D: Nükleer Test', 'EN': 'D: Nuclear Test'},
    'l2_s2_story': {'TR': "YARATIK DNA'SI BULUNDU.\nEksik baz çiftini tamamla.\n(Guanin - Sitozin, Adenin - Timin)", 'EN': "CREATURE DNA FOUND.\nComplete the base pair.\n(Guanine - Cytosine, Adenine - Thymine)"},
    'l2_s2_q': {'TR': 'G - C - A - ?', 'EN': 'G - C - A - ?'},
    'l2_s2_opt1': {'TR': 'G (Guanin)', 'EN': 'G (Guanine)'},
    'l2_s2_opt2': {'TR': 'T (Timin)', 'EN': 'T (Thymine)'},
    'l2_s3_story': {'TR': "Yaratığın vücut ısısı artıyor. Buz eriyor.\nDakikada 5cm eriyorsa, 300cm buz kaç dakikada erir?", 'EN': "Creature body heat rising. Ice melting.\nIf 5cm melts/min, how long for 300cm?"},
    'l2_s3_input': {'TR': 'DAKİKAYI GİR', 'EN': 'ENTER MINUTES'},
    'l2_reward': {'TR': 'Canlı Türü: BİLİNMEYEN.\nSinyal Okyanusu Gösteriyor.', 'EN': 'Species: UNKNOWN.\nSignal Points to Ocean.'},

    // --- LEVEL 3: OKYANUS (HİKAYE GÜNCELLENDİ - HADES) ---
    'l3_title': {'TR': 'SEVİYE 3: HADES KAPISI', 'EN': 'LEVEL 3: HADES GATE'},
    'l3_s1_story': {'TR': "Manyetik alan bozuldu. Pusula +5 derece saptı.\nŞifreyi bu sapmaya göre çöz: J-K-N-G-T", 'EN': "Magnetic field corrupted. Compass +5 deviation.\nDecode based on deviation: J-K-N-G-T"},
    'l3_s2_story': {'TR': "Derinlerden bir sinyal geliyor.\n... --- ... (Mors Rehberini kullan)", 'EN': "Signal from the deep.\n... --- ... (Use Morse Guide)"},
    'l3_s3_story': {'TR': "Kapı Şifresi İsteniyor.\nYaratığın kod adı neydi? (Yunan Yeraltı Tanrısı)", 'EN': "Gate Password Required.\nCreature's codename? (Greek God of Underworld)" },
    'l3_reward': {'TR': 'HADES UYANDI.\nZihin Kontrolü Kaybediliyor...', 'EN': 'HADES AWAKENED.\nLosing Mind Control...'},

    // --- LEVEL 4: ZİHİN (HİKAYE GÜNCELLENDİ - FİNAL) ---
    'l4_title': {'TR': 'SEVİYE 4: ZİHİN KIRILMASI', 'EN': 'LEVEL 4: MIND FRACTURE'},
    'l4_s1_story': {'TR': "Gerçeklik parçalanıyor.\nKoordinatları birleştir (C7, D6, E5).\nÇıkış yolu hangi yıldızda?", 'EN': "Reality fracturing.\nConnect coordinates (C7, D6, E5).\nWhich star is the exit?"},
    'l4_task': {'TR': 'SABİT NOKTAYI SEÇ', 'EN': 'SELECT FIXED POINT'},
    'l4_s2_story': {'TR': "Halüsinasyon görüyorsun. İlaç karışımı yap.\nHidrojen (1) ve Oksijen (8) oranı nedir?", 'EN': "Hallucinating. Mix the antidote.\nRatio of Hydrogen (1) to Oxygen (8)?"},
    'l4_s2_opt1': {'TR': '1:8', 'EN': '1:8'},
    'l4_s2_opt2': {'TR': '2:1', 'EN': '2:1'},
    'l4_s3_story': {'TR': "ZİHNİN SANA OYUN OYNUYOR.\n'MAVİ' yazısına basma. 'KIRMIZI'ya basma. \nSadece YEŞİL renkli kutuya güven.", 'EN': "YOUR MIND IS PLAYING TRICKS.\nDon't press 'BLUE'. Don't press 'RED'.\nTrust only the GREEN box."},
    'l4_reward': {'TR': "SENKRONİZASYON TAMAMLANDI.\nTriverse Simülasyonu Sona Erdi.", 'EN': "SYNCHRONIZATION COMPLETE.\nTriverse Simulation Ended."},

    // --- SATIN ALMA (MEVCUT) ---
    'sale_text': {'TR': '%37 İNDİRİM!', 'EN': '37% SALE!'},
    'stock_text': {'TR': 'Son 12 kutu kaldı!', 'EN': 'Only 12 boxes left!'},
    'buy_now': {'TR': 'HEMEN SATIN AL', 'EN': 'BUY NOW'},
    'redirect_msg': {'TR': 'Ödeme sayfasına yönlendiriliyorsunuz...', 'EN': 'Redirecting to payment...'},
    'secure_pay': {'TR': 'Güvenli Ödeme', 'EN': 'Secure Payment'},
    'shipping': {'TR': '2 Günde Kargo', 'EN': '2-Day Shipping'},
    'original': {'TR': 'Orijinal Ürün', 'EN': 'Original Product'},
  };
}