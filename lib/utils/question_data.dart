class Question {
  final int id;
  final String text; 
  final Map<String, String> options;
  final String correctOption;

  Question(this.id, this.text, this.options, this.correctOption);
}

class QuestionData {
  static List<Question> getAll() {
    return [
      // KOLAY (1-7)
      Question(1, "Geceleri buzulların içinden duyulan 'çatırdayan fısıltılar' nedir?", 
        {'A': 'Donmuş ruhlar', 'B': 'Buzun gerilme sesi', 'C': 'Hayvan dili', 'D': 'Kabile davulu'}, 'B'),
      Question(2, "Buz mağaralarının mavi parıldamasının nedeni nedir?", 
        {'A': 'Büyülü mineraller', 'B': 'Işığı süzme biçimi', 'C': 'Ateş böcekleri', 'D': 'Mitolojik periler'}, 'B'),
      Question(3, "Gezginlerin hissettiği 'buzul nefesi' nasıl oluşur?", 
        {'A': 'Yaratık soluğu', 'B': 'Havanın çatlaklardan çıkması', 'C': 'Kutup hortumu', 'D': 'Sıcak su buharı'}, 'B'),
      Question(4, "Buzulların üzerindeki siyah 'gecenin gözleri' lekeleri nedir?", 
        {'A': 'Kül', 'B': 'Yıldırım izi', 'C': 'Cryoconite (Mikroskobik canlılar)', 'D': 'Donmuş gölge'}, 'C'),
      Question(5, "Buzul altından gelen davul sesleri genellikle nedir?", 
        {'A': 'Mağara canavarları', 'B': 'Buzul altı nehirler', 'C': 'Kaya ruhları', 'D': 'Atmosferik yankı'}, 'B'),
      Question(6, "Eskimoların 'tiriġnaq' (gölgemsi varlıklar) dediği şey nedir?", 
        {'A': 'Ay yansıması', 'B': 'Ayı gölgesi', 'C': 'Buz sisi siluetleri', 'D': 'Aurora gölgesi'}, 'C'),
      Question(7, "Buzulda duyulan 'kükreme' neyin işaretidir?", 
        {'A': 'Uyarı', 'B': 'Fırtına', 'C': 'Buzun kırılması', 'D': 'Devlerin uyanışı'}, 'C'),

      // ORTA (8-14)
      Question(8, "Buz çökmelerinde görülen 'mavi ateş' ışık halesi nedir?", 
        {'A': 'Ruh dansı', 'B': 'Piezoelektrik', 'C': 'Soğuk plazma', 'D': 'Yansıyan yıldız ışığı'}, 'D'),
      Question(9, "Buzulların 'içeri nefes alması' hangi olaya benzer?", 
        {'A': 'Gel-git', 'B': 'Basınç değişimi', 'C': 'Ruh beslenmesi', 'D': 'Manyetik alan'}, 'B'),
      Question(10, "Buzul göllerinin aniden boşalmasına ne denir?", 
        {'A': 'Buz gözyaşı', 'B': 'Kıyamet sızması', 'C': 'GLOF', 'D': 'Polaris yarılması'}, 'C'),
      Question(11, "Izdırap koridorundaki inilti sesleri aslında nedir?", 
        {'A': 'Donmuş çığlık', 'B': 'Buz-kaya sürtünmesi', 'C': 'Geçmişin yankısı', 'D': 'Yeraltı rüzgarı'}, 'B'),
      Question(12, "Buz tünelleri neden mavi parlar?", 
        {'A': 'Buz cinleri', 'B': 'Mavi ışığı geçirmesi', 'C': 'Göktaşı', 'D': 'Biyolüminesans'}, 'B'),
      Question(13, "Kuzey halklarının 'buz sirenleri' dediği ses nedir?", 
        {'A': 'Ruh şarkısı', 'B': 'Rüzgarın çatlaklardan geçmesi', 'C': 'Radyo sinyali', 'D': 'Balina yankısı'}, 'B'),
      Question(14, "Buzul altındaki sıcak suyun kaynağı nedir?", 
        {'A': 'Ateş tanrıları', 'B': 'Volkanik aktivite', 'C': 'Güneş yansıması', 'D': 'Sürtünme ısısı'}, 'B'),

      // ZOR (15-20)
      Question(15, "Antarktika'daki 'Kan Şelalesi'nin rengi neden kırmızıdır?", 
        {'A': 'Canlı kanı', 'B': 'Demir oksitlenmesi', 'C': 'Yaratık erimesi', 'D': 'Kızıl plankton'}, 'B'),
      Question(16, "Buzul altındaki 'karanlık nehirlerin' sebebi nedir?", 
        {'A': 'Büyü', 'B': 'Basınçla eriyen buz', 'C': 'Kanal sistemi', 'D': 'Jeotermal tünel'}, 'B'),
      Question(17, "'Buzulları koruyan dev uyur' titreşimleri nedir?", 
        {'A': 'Dünya dönmesi', 'B': 'Deprem dalgaları', 'C': 'Hayvan adımları', 'D': 'Meteor'}, 'B'),
      Question(18, "Düşük frekanslı 'hum' sesi neye bağlıdır?", 
        {'A': 'Buz rezonansı', 'B': 'Yaratık hırıltısı', 'C': 'Yıldırım enerjisi', 'D': 'Elektromıknatıs'}, 'A'),
      Question(19, "Buzul altı mikropları neden gizemlidir?", 
        {'A': 'Zihin kontrolü', 'B': 'Güneşsiz yaşam', 'C': 'Bilinçli davranış', 'D': 'Isı üretimi'}, 'B'),
      Question(20, "Mağaralardaki metalik çınlama sesi neden olur?", 
        {'A': 'Silah sesi', 'B': 'Gerilme titreşimleri', 'C': 'Manyetik alan', 'D': 'Antik çanlar'}, 'B'),
    ];
  }

  static Question? getById(int id) {
    try {
      return getAll().firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }
}