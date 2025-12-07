class AppTexts {
  static String get(String key, String lang) {
    if (_localizedValues.containsKey(key)) {
      return _localizedValues[key]?[lang] ?? key;
    }
    return "MISSING: $key";
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    // --- GENEL METİNLER ---
    'play': {'TR': 'OYNA', 'EN': 'PLAY'},
    'buy': {'TR': 'SATIN AL', 'EN': 'BUY'},
    'pause_msg': {'TR': 'Oyun molası veriliyor...', 'EN': 'Game paused...'},
    'start_link': {'TR': 'BAĞLANTIYI BAŞLAT', 'EN': 'INITIATE LINK'},
    'mission_select': {'TR': 'GÖREV SEÇİMİ (16 FAZ)', 'EN': 'MISSION SELECT'},
    
    // FAZ İSİMLERİ (GÜNCELLENDİ)
    'zone_1_title': {'TR': 'FAZ 1: BUZULLAR', 'EN': 'PHASE 1: GLACIERS'},
    'zone_2_title': {'TR': 'FAZ 2: OKYANUS', 'EN': 'PHASE 2: OCEAN'}, // Gelecek
    'zone_3_title': {'TR': 'FAZ 3: UZAY', 'EN': 'PHASE 3: SPACE'},   // Gelecek
    'zone_4_title': {'TR': 'FAZ 4: KAOS', 'EN': 'PHASE 4: CHAOS'},   // Gelecek

    'locked_msg': {'TR': 'Önceki seviyeyi tamamla!', 'EN': 'Complete previous level!'},
    'check': {'TR': 'KONTROL ET', 'EN': 'CHECK'},
    'retry': {'TR': 'HATALI! Tekrar Dene', 'EN': 'ERROR! Retry'},
    'try_again': {'TR': 'HATALI KOD / SEÇİM', 'EN': 'INVALID CODE / SELECTION'},
    'success': {'TR': 'BAŞARILI', 'EN': 'SUCCESS'},
    'continue': {'TR': 'DEVAM ET', 'EN': 'CONTINUE'},
    'stage_prefix': {'TR': 'AŞAMA', 'EN': 'STAGE'},

    // --- GİRİŞ HİKAYESİ ---
    'intro_story': {
      'TR': "> GÜVENLİ HAT KURULUYOR...\n> YIL: 2084\n\nKutuplardaki araştırma istasyonumuzdan gelen sinyal kesildi.\nSon veriler, buzun altında devasa bir enerji dalgalanması gösteriyor.\n\nBu bir kurtarma görevi değil. Bu bir keşif görevi.\n\nBuzun altındaki 'Şey' uyanıyor.\nOkyanusun derinliklerinden fısıltılar geliyor.\n\nGörevin: İstasyonu aç. Yaratığı analiz et. Zihnini koru.\n\n> SİSTEM HAZIR.",
      'EN': "> SECURE LINE ESTABLISHED...\n> YEAR: 2084\n\nSignal lost from the Polar Research Station.\nLast data shows massive energy fluctuations beneath the ice.\n\nThis is not a rescue mission. This is a discovery mission.\n\nThe 'Thing' beneath the ice is waking up.\nWhispers are rising from the ocean depths.\n\nYour mission: Power the station. Analyze the creature. Protect your mind.\n\n> SYSTEM READY."
    },

    // --- FİZİKİ KART SİSTEMİ ---
    'card_alert_title': {'TR': 'FİZİKİ KART GEREKLİ', 'EN': 'PHYSICAL CARD REQUIRED'},
    'card_instruction': {
      'TR': 'Oyuna devam etmek için gerçek dünyadaki bilgi kartını kullanmalısın. Kartı çek, numarayı gir.',
      'EN': 'You must use the physical info card in the real world. Draw card, enter ID.'
    },
    'card_btn_read': {'TR': 'KARTI OKUDUM', 'EN': 'I HAVE READ THE CARD'},
    'card_wrong': {'TR': 'Yanlış Bilgi! Kartı tekrar oku.', 'EN': 'Wrong Info! Read card again.'},
    'card_input_hint': {'TR': 'KART NO (Örn: 5)', 'EN': 'CARD ID (Ex: 5)'},
    'card_scan_btn': {'TR': 'VERİLERİ GETİR', 'EN': 'FETCH DATA'},

    // ============================================================
    // LEVEL 1: İSTASYON (MEVCUT KORUNDU)
    // ============================================================
    'l1_title': {'TR': 'BÖLÜM 1: İSTASYON', 'EN': 'LEVEL 1: STATION'},
    'l1_s1_header': {'TR': 'SİNYAL TESPİT EDİLDİ', 'EN': 'SIGNAL DETECTED'}, 
    // Diğer L1 metinleri hardcoded olabilir, ancak buraya eklenmesi gerekenler varsa eklenir.

    // ============================================================
    // LEVEL 2: BIOLAB (MEVCUT KORUNDU)
    // ============================================================
    'l2_title': {'TR': 'BÖLÜM 2: BIOLAB', 'EN': 'LEVEL 2: BIOLAB'},
    'l2_s1_header': {'TR': 'KATMAN ANALİZİ', 'EN': 'LAYER ANALYSIS'},
    'l2_s1_story': {'TR': "Buzulun içindeki katmanları analiz et.\nYENİDEN ESKİYE doğru sırala.", 'EN': "Analyze layers within the glacier.\nOrder from NEW to OLD."},
    'l2_btn_process': {'TR': 'ANALİZİ BAŞLAT', 'EN': 'START ANALYSIS'},

    'l2_p1_header': {'TR': 'DNA SARMALI', 'EN': 'DNA HELIX'},
    'l2_p1_story': {'TR': "YARATIK DNA'SI BULUNDU.\nEksik baz çiftini tamamla.\n(Guanin - Sitozin, Adenin - Timin)\nDizi: G - C - A - ?", 'EN': "CREATURE DNA FOUND.\nComplete the base pair.\n(Guanine - Cytosine, Adenine - Thymine)\nSeq: G - C - A - ?"},

    'l2_c1_header': {'TR': 'BİYOLOJİK ÖRNEK', 'EN': 'BIOLOGICAL SAMPLE'},
    'l2_c1_story': {'TR': 'Bulunan doku örneğini analiz etmek için Biyoloji Kartını tarat.', 'EN': 'Scan the Biology Card to analyze the tissue sample.'},

    // L2 - Riddle 1
    'l2_r1_header': {'TR': 'TARİHSEL KATMANLAR', 'EN': 'HISTORICAL LAYERS'},
    'l2_r1_story': {'TR': 'Hangi sıralama günümüzden geçmişe doğrudur?', 'EN': 'Which order is from present to past?'},
    'l2_r1_opt1': {'TR': 'Buzul Çağı > Sanayi Devrimi', 'EN': 'Ice Age > Industrial Rev.'},
    'l2_r1_opt2': {'TR': 'Sanayi Devrimi > Buzul Çağı', 'EN': 'Industrial Rev. > Ice Age'},
    'l2_r1_opt3': {'TR': 'Volkan Patlaması > Nükleer Test', 'EN': 'Volcano > Nuclear Test'},
    'l2_r1_opt4': {'TR': 'Dinozorlar > Romalılar', 'EN': 'Dinosaurs > Romans'},

    // L2 - Puzzle 2
    'l2_p2_header': {'TR': 'ERİME HIZI', 'EN': 'MELT RATE'},
    'l2_p2_story': {'TR': "Yaratığın vücut ısısı artıyor. Buz eriyor.\nDakikada 5cm eriyorsa, 300cm buz kaç dakikada erir?", 'EN': "Creature body heat rising. Ice melting.\nIf 5cm melts/min, how long for 300cm?"},
    // Cevap "60" hardcoded kontrol ediliyor, şıklar yok.

    // L2 - Riddle 2
    'l2_r2_header': {'TR': 'HÜCRE YAPISI', 'EN': 'CELL STRUCTURE'},
    'l2_r2_story': {'TR': 'Bu yaratığın hücre duvarı yok ama donmuyor. Hangi madde buna sebep olur?', 'EN': 'No cell wall but doesn\'t freeze. Which substance causes this?'},
    'l2_r2_opt1': {'TR': 'Su', 'EN': 'Water'},
    'l2_r2_opt2': {'TR': 'Antifriz Proteini', 'EN': 'Antifreeze Protein'},
    'l2_r2_opt3': {'TR': 'Tuz', 'EN': 'Salt'},
    'l2_r2_opt4': {'TR': 'Demir', 'EN': 'Iron'},

    // L2 - Puzzle 3
    'l2_p3_header': {'TR': 'SİSTEM HATASI', 'EN': 'SYSTEM FAILURE'},
    'l2_p3_story': {'TR': 'Analiz tamamlanamıyor. Biyolojik tehlike seviyesi nedir?', 'EN': 'Analysis incomplete. What is the biohazard level?'},
    'l2_p3_opt1': {'TR': 'SEVİYE 5 (Kıyamet)', 'EN': 'LEVEL 5 (Doomsday)'},
    'l2_p3_opt2': {'TR': 'SEVİYE 1 (Düşük)', 'EN': 'LEVEL 1 (Low)'},
    'l2_p3_opt3': {'TR': 'GÜVENLİ', 'EN': 'SAFE'},


    // ============================================================
    // LEVEL 3: DERİN ÇATLAK (TAMAMEN YENİLENDİ - BUZULLAR FAZ 2)
    // ============================================================
    'l3_title': {'TR': 'BÖLÜM 3: DERİN ÇATLAK', 'EN': 'LEVEL 3: THE CREVASSE'},
    'l3_s1_header': {'TR': 'DÜŞÜŞ BAŞLIYOR', 'EN': 'DESCENT BEGINS'},
    'l3_s1_story': {'TR': 'İstasyonun altındaki zemin çöktü. 500 metre aşağıdaki antik bir mağaraya indik. Burası milyonlarca yıldır mühürlüydü. Duvarlarda donmuş devasa gölgeler var.', 'EN': 'Ice floor collapsed. We fell 500m into an ancient cave. Sealed for millions of years. Frozen shadows on walls.'},
    
    // L3 - Riddle 1
    'l3_r1_header': {'TR': 'DONMA RİSKİ', 'EN': 'FREEZE RISK'},
    'l3_r1_story': {'TR': 'Vücut ısımız düşüyor. Hipotermi belirtisi OLMAYAN hangisidir?', 'EN': 'Body temp dropping. Which is NOT a sign of hypothermia?'},
    'l3_r1_opt1': {'TR': 'Titreme', 'EN': 'Shivering'},
    'l3_r1_opt2': {'TR': 'Aşırı Terleme', 'EN': 'Excessive Sweating'},
    'l3_r1_opt3': {'TR': 'Zihin Bulanıklığı', 'EN': 'Confusion'},
    'l3_r1_opt4': {'TR': 'Uyuşukluk', 'EN': 'Drowsiness'},

    // L3 - Riddle 2
    'l3_r2_header': {'TR': 'BUZUL TARİHİ', 'EN': 'GLACIAL HISTORY'},
    'l3_r2_story': {'TR': 'Bu mağara "Kriyojenik" dönemden kalma. Bu terim ne anlama gelir?', 'EN': 'Cave is from "Cryogenic" era. What does it mean?'},
    'l3_r2_opt1': {'TR': 'Ateş Üretimi', 'EN': 'Fire Production'},
    'l3_r2_opt2': {'TR': 'Çok Düşük Sıcaklık', 'EN': 'Very Low Temperature'},
    'l3_r2_opt3': {'TR': 'Yüksek Basınç', 'EN': 'High Pressure'},
    'l3_r2_opt4': {'TR': 'Radyasyon', 'EN': 'Radiation'},


    // ============================================================
    // LEVEL 4: ÇEKİRDEK (TAMAMEN YENİLENDİ - BUZULLAR FAZ 3/FINAL)
    // ============================================================
    'l4_title': {'TR': 'BÖLÜM 4: ÇEKİRDEK', 'EN': 'LEVEL 4: THE CORE'},
    'l4_s1_header': {'TR': 'ISINAN BUZ', 'EN': 'WARMING ICE'},
    'l4_s1_story': {'TR': 'Mağaranın en dibindeyiz. Burada fizik kuralları işlemiyor. Dışarısı -60 dereceyken, burası +25 derece. Buzun içinde devasa, atan bir biyolojik yapı var.', 'EN': 'Bottom of the cave. Physics is broken here. Outside -60C, here +25C. A massive, beating biological structure inside the ice.'},

    // L4 - Riddle 1
    'l4_r1_header': {'TR': 'ANOMALİ', 'EN': 'ANOMALY'},
    'l4_r1_story': {'TR': 'Buzulun altında sıvı su gölü bulundu. Buna ne ad verilir?', 'EN': 'Liquid lake found under glacier. What is it called?'},
    'l4_r1_opt1': {'TR': 'Subglasiyal Göl', 'EN': 'Subglacial Lake'}, // Doğru
    'l4_r1_opt2': {'TR': 'Gayzer', 'EN': 'Geyser'},
    'l4_r1_opt3': {'TR': 'Fjord', 'EN': 'Fjord'},
    'l4_r1_opt4': {'TR': 'Tundra', 'EN': 'Tundra'},

    // L4 - Riddle 2
    'l4_r2_header': {'TR': 'YENİ TÜR', 'EN': 'NEW SPECIES'},
    'l4_r2_story': {'TR': 'Organizma ışıksız ortamda enerji üretiyor. Bu sürece ne denir?', 'EN': 'Organism makes energy without light. What is this process?'},
    'l4_r2_opt1': {'TR': 'Fotosentez', 'EN': 'Photosynthesis'},
    'l4_r2_opt2': {'TR': 'Kemosentez', 'EN': 'Chemosynthesis'}, // Doğru
    'l4_r2_opt3': {'TR': 'Elektroliz', 'EN': 'Electrolysis'},
    'l4_r2_opt4': {'TR': 'Osmoz', 'EN': 'Osmosis'},
    
    // KOORDİNAT SİSTEMİ
    'coord_reward': {'TR': 'KOORDİNAT PARÇASI AÇILDI: [X: 14 - Y: 88]', 'EN': 'COORDINATE UNLOCKED: [X: 14 - Y: 88]'},
    'lyra_hint': {'TR': 'Bu koordinatı fiziksel haritana işle.', 'EN': 'Mark this on your physical map.'},

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
