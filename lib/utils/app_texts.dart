class AppTexts {
  static String get(String key, String lang) {
    if (_localizedValues.containsKey(key)) {
      return _localizedValues[key]?[lang] ?? key;
    }
    return "MISSING: $key";
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    // --- GENEL ---
    'play': {'TR': 'OYNA', 'EN': 'PLAY'},
    'buy': {'TR': 'SATIN AL', 'EN': 'BUY'},
    'pause_msg': {'TR': 'Oyun molası veriliyor...', 'EN': 'Game paused...'},
    'start_link': {'TR': 'BAĞLANTIYI BAŞLAT', 'EN': 'INITIATE LINK'},
    'intro_story': {
      'TR': "> GÜVENLİ HAT KURULUYOR...\n> YIL: 2084\n\nDünya'nın uç noktalarından ve uzaydan tuhaf sinyaller alıyoruz.\nÖncü ekiplerimizle bağlantı kesildi.\n\nKutupların buzlu sessizliği...\nOkyanusun karanlık derinliği...\nVe uzayın sonsuz boşluğu...\n\nGöreviniz: Sinyalleri takip et. Bulmacaları çöz.\nBize koordinatları gönder.\n\nParçaları birleştirdiğinde...\nGerçeği göreceksin.\n\n> SİSTEM HAZIR.",
      'EN': "> SECURE LINE ESTABLISHED...\n> YEAR: 2084\n\nWe are receiving strange signals from the ends of the Earth and space.\nContact with pioneer teams has been lost.\n\nThe icy silence of the poles...\nThe dark depths of the ocean...\nAnd the infinite void of space...\n\nYour mission: Trace the signals. Solve the puzzles. Send us the coordinates.\n\nWhen you assemble the pieces...\nYou will see the truth.\n\n> SYSTEM READY."
    },
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

    // --- FİZİKİ KART SİSTEMİ ---
    'card_alert_title': {'TR': 'FİZİKİ KART GEREKLİ', 'EN': 'PHYSICAL CARD REQUIRED'},
    'card_alert_desc': {
      'TR': 'Oyuna devam etmek için gerçek dünyadaki bilgi kartını kullanmalısın.',
      'EN': 'You must use the physical info card in the real world to proceed.'
    },
    'card_btn_read': {'TR': 'KARTI OKUDUM', 'EN': 'I HAVE READ THE CARD'},
    'card_wrong': {'TR': 'Yanlış Bilgi! Kartı tekrar oku.', 'EN': 'Wrong Info! Read card again.'},

    // KART 1
    'c1_name': {'TR': 'KART #1: KARIN GÜCÜ', 'EN': 'CARD #1: POWER OF SNOW'},
    'c1_q': {'TR': 'Fırtına çıktı! Donmak üzeresin. Karttaki bilgiye göre ne yapmalısın?', 'EN': 'Storm hits! Freezing. Based on the card, what should you do?'},
    'c1_a': {'TR': 'Koşarak ısın', 'EN': 'Run to warm up'},
    'c1_b': {'TR': 'Kar çukuru kaz', 'EN': 'Dig snow hole'},

    // KART 2
    'c2_name': {'TR': 'KART #2: BEYAZ KARANLIK', 'EN': 'CARD #2: WHITEOUT'},
    'c2_q': {'TR': 'Her yer bembeyaz (Whiteout). Derinlik algın yok. Nasıl ilerlemelisin?', 'EN': 'Whiteout conditions. No depth perception. How to proceed?'},
    'c2_a': {'TR': 'Siyah obje at', 'EN': 'Throw dark object'},
    'c2_b': {'TR': 'Gözlerine güven', 'EN': 'Trust your eyes'},

    // KART 3
    'c3_name': {'TR': 'KART #3: AVCI BARINAĞI', 'EN': 'CARD #3: HUNTER SHELTER'},
    'c3_q': {'TR': 'Eski bir et deposu buldun. Çok açsın. Hangi eti YEMEMELİSİN?', 'EN': 'Found old meat stash. Starving. Which meat MUST you avoid?'},
    'c3_a': {'TR': 'Kas Eti', 'EN': 'Muscle Meat'},
    'c3_b': {'TR': 'Ayı Ciğeri', 'EN': 'Bear Liver'},

    // KART 4
    'c4_name': {'TR': 'KART #4: ALBEDO ETKİSİ', 'EN': 'CARD #4: ALBEDO EFFECT'},
    'c4_q': {'TR': 'Buzul eriyor. Karşıya geçmek için hangi zemine basmalısın?', 'EN': 'Glacier melting. Which surface is safer to step on?'},
    'c4_a': {'TR': 'Koyu Mavi Buz', 'EN': 'Dark Blue Ice'},
    'c4_b': {'TR': 'Beyaz Karlı Buz', 'EN': 'White Snowy Ice'},

    // --- LEVEL 1 ---
    'l1_title': {'TR': 'SEVİYE 1: ISI DENGESİ', 'EN': 'LEVEL 1: HEAT BALANCE'},
    'l1_s1_story': {'TR': "Dış Kapı (-60°C). Kapı kilitli.\nEnerji akışını dengele (Net: 0).", 'EN': "Outer Door (-60°C). Locked.\nBalance energy flow (Net: 0)."},
    'l1_s1_task': {'TR': 'SORU İŞARETİ (?) KAÇ OLMALI?', 'EN': 'VALUE OF (?)?'},
    'l1_s2_story': {'TR': "Sesli doğrulama isteniyor.\nBu bilmecenin cevabı nedir?", 'EN': "Voice auth required.\nWhat is the answer?"},
    'l1_s2_riddle': {'TR': "\"Kanadım yok uçarım. Gözüm yok ağlarım.\nKaranlık beni takip eder.\nBen neyim?\"", 'EN': "\"I fly without wings. I cry without eyes.\nDarkness follows me.\nWhat am I?\""},
    'l1_s2_opt1': {'TR': 'RÜZGAR', 'EN': 'WIND'},
    'l1_s2_opt2': {'TR': 'BULUT', 'EN': 'CLOUD'},
    'l1_s2_opt3': {'TR': 'UÇAK', 'EN': 'PLANE'},
    'l1_s3_story': {'TR': "Basınç arttı! Valfleri ASAL SAYI sırasına göre aç.\n(2, 3, 5, 7...)", 'EN': "Pressure rising! Open valves in PRIME NUMBER order.\n(2, 3, 5, 7...)"},
    'l1_reward': {'TR': 'Kutuplar Tamamlandı.\nVeri Parçası: C-7', 'EN': 'Poles Completed.\nData Fragment: C-7'},

    // --- LEVEL 2 ---
    'l2_title': {'TR': 'SEVİYE 2: BUZ TARİHİ', 'EN': 'LEVEL 2: ICE HISTORY'},
    'l2_s1_story': {'TR': "Laboratuvar. Virüsü bulmak için katmanları\nYENİDEN ESKİYE doğru sırala.", 'EN': "Lab. Order layers from NEW to OLD\nto isolate the virus."},
    'l2_optA': {'TR': 'A: Sanayi Devrimi', 'EN': 'A: Industrial Rev.'},
    'l2_optB': {'TR': 'B: Toba Volkanı', 'EN': 'B: Toba Volcano'},
    'l2_optC': {'TR': 'C: Buzul Çağı', 'EN': 'C: Ice Age'},
    'l2_optD': {'TR': 'D: Nükleer Test', 'EN': 'D: Nuclear Test'},
    'l2_s2_story': {'TR': "Virüs DNA'sı bozuk.\nEksik baz çiftini tamamla.\n(Guanin - Sitozin, Adenin - Timin)", 'EN': "Virus DNA corrupted.\nComplete the base pair.\n(Guanine - Cytosine, Adenine - Thymine)"},
    'l2_s2_q': {'TR': 'G - C - A - ?', 'EN': 'G - C - A - ?'},
    'l2_s2_opt1': {'TR': 'G (Guanin)', 'EN': 'G (Guanine)'},
    'l2_s2_opt2': {'TR': 'T (Timin)', 'EN': 'T (Thymine)'},
    'l2_s3_story': {'TR': "Buz erime hızı arttı.\nDakikada 5cm eriyorsa, 300cm buz kaç dakikada erir?", 'EN': "Ice melting fast.\nIf 5cm melts per min, how long for 300cm?"},
    'l2_s3_input': {'TR': 'DAKİKAYI GİR', 'EN': 'ENTER MINUTES'},
    'l2_reward': {'TR': 'Okyanus Tamamlandı.\nVeri Parçası: D-6', 'EN': 'Ocean Completed.\nData Fragment: D-6'},

    // --- LEVEL 3 ---
    'l3_title': {'TR': 'SEVİYE 3: SİNYAL', 'EN': 'LEVEL 3: SIGNAL'},
    'l3_s1_story': {'TR': "Pusula sapmış (+5 Doğu).\nŞifreyi çöz: J-K-N-G-T", 'EN': "Compass deviated (+5 East).\nDecode: J-K-N-G-T"},
    'l3_s2_story': {'TR': "Acil durum sinyali alınıyor.\n... --- ... (Bu ne anlama gelir?)", 'EN': "Emergency signal received.\n... --- ... (Meaning?)"},
    'l3_s3_story': {'TR': "Sinyal çok gürültülü.\nFrekansı 440 Hz (La Notası) yap.", 'EN': "Signal noisy.\nTune frequency to 440 Hz (Note A)." },
    'l3_reward': {'TR': 'Uzay Tamamlandı.\nVeri Parçası: E-5', 'EN': 'Space Completed.\nData Fragment: E-5'},

    // --- LEVEL 4 ---
    'l4_title': {'TR': 'SEVİYE 4: KUTUP YILDIZI', 'EN': 'LEVEL 4: POLARIS'},
    'l4_s1_story': {'TR': "Navigasyon.\n(C7, D6, E5) birleştir.\nSon parça (Kutup Yıldızı) neresi?", 'EN': "Navigation.\nConnect (C7, D6, E5).\nWhere is the final piece (North Star)?"},
    'l4_task': {'TR': 'SON YILDIZI SEÇ', 'EN': 'SELECT FINAL STAR'},
    'l4_s2_story': {'TR': "Yakıt karışımı.\nHidrojen (1) ve Oksijen (8) atom ağırlıkları oranı nedir?", 'EN': "Fuel mix.\nRatio of Hydrogen (1) to Oxygen (8) atomic weight?"},
    'l4_s2_opt1': {'TR': '1:8', 'EN': '1:8'},
    'l4_s2_opt2': {'TR': '2:1', 'EN': '2:1'},
    'l4_s3_story': {'TR': "Sistem aşırı ısındı.\nMAVİ'ye basma. KIRMIZI'ya basma. YEŞİL'e bas.", 'EN': "System Overheat.\nDon't press BLUE. Don't press RED. Press GREEN."},
    'l4_reward': {'TR': "BÖLGE 1 TAMAMLANDI.\nSıradaki: OKYANUS.", 'EN': "ZONE 1 COMPLETED.\nNext: OCEAN."},

    // --- SATIN ALMA ---
    'sale_text': {'TR': '%37 İNDİRİM!', 'EN': '37% SALE!'},
    'stock_text': {'TR': 'Son 12 kutu kaldı!', 'EN': 'Only 12 boxes left!'},
    'buy_now': {'TR': 'HEMEN SATIN AL', 'EN': 'BUY NOW'},
    'redirect_msg': {'TR': 'Ödeme sayfasına yönlendiriliyorsunuz...', 'EN': 'Redirecting to payment...'},
    'secure_pay': {'TR': 'Güvenli Ödeme', 'EN': 'Secure Payment'},
    'shipping': {'TR': '2 Günde Kargo', 'EN': '2-Day Shipping'},
    'original': {'TR': 'Orijinal Ürün', 'EN': 'Original Product'},
  };
}