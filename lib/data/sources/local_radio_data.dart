import '../models/radio_station.dart';

class LocalRadioData {
  static const List<RadioStation> globalStations = [
    RadioStation(
      name: "Quran Radio",
      description: "24/7 Holy Quran recitation",
      url: "https://stream.radiojar.com/quran-hafs-sulami",
      flag: "🕌",
    ),
    RadioStation(
      name: "Makkah Live",
      description: "Live recitations from Masjid Al-Haram",
      url: "https://Qurango.net/radio/tarateel",
      flag: "🕋",
    ),
    RadioStation(
      name: "Islamic Reminders",
      description: "Lectures and spiritual reminders",
      url: "https://stream.zeno.fm/0r0xa792kwzuv",
      flag: "📖",
    ),
    RadioStation(
      name: "Madinah Radio",
      description: "Live from Masjid An-Nabawi",
      url: "https://stream.radiojar.com/madinah",
      flag: "🌙",
    ),
    RadioStation(
      name: "Quran Kareem",
      description: "Soulful recitation around the clock",
      url: "https://n0d.radiojar.com/csp2r04750quv?rj-ttl=5&rj-tok=AAABkVZH_xMADHIBXXxmh9g5VA",
      flag: "✨",
    ),
  ];
}
