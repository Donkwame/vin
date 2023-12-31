import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// vin_decoder_page.dart

class VinDecoderWidget extends StatefulWidget {
  const VinDecoderWidget({super.key});

  @override
  VinDecoderWidgetState createState() => VinDecoderWidgetState();
}

class VinDecoderWidgetState extends State<VinDecoderWidget> {
  // ... (rest of your VinDecoderWidgetState code)

  String vin = '';
  String wmiCode = '';
  String decodingResult = '';
  String decodeVehicleDetails = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                vin = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Enter VIN',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              validateAndDecodeVin(context);
            },
            child: const Text('Decode VIN and WMI Code'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Decoding Result:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(decodingResult),
        ],
      ),
    );
  }

  void validateAndDecodeVin(BuildContext context) async {
    if (vin.length != 17) {
      showValidationMessage(context, 'The VIN number is not 17 characters.');
      return;
    }

    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(vin)) {
      showValidationMessage(context,
          'Invalid VIN number. Must be a mixture of uppercase letters and numbers.');
      return;
    }

    try {
      final details = decodeVehicleDetails;
      // Handle the decoded details as needed
      logger.d('Decoded VIN details: $details');
    } catch (e) {
      // Handle errors during decoding
      logger.e('Error decoding VIN: $e');
    }
    
    decodeVin();
    decodeWmiCode(); // Call the WMI decoding method
  }

  void showValidationMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('VIN Validation'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void decodeVin() async {
    try {
      final decoder = VinDecoder();
      decoder.decodeVin(vin);

      setState(() {
        decodingResult = '''
          VIN Decoding Result:
          Country: ${decoder.country}
          Make: ${decoder.make}
          Continent: ${decoder.continent}
          Model Year: ${decoder.modelYear}
          Engine Size: ${decoder.engineSize}
          Model: ${decoder.wmiDetails}
          Body Style: ${decoder.bodyStyle}
          Engine Type: ${decoder.engineType}


        ''';
      });
    } catch (e) {
      setState(() {
        decodingResult = 'Error decoding VIN: $e';
      });
    }
  }

  void decodeWmiCode() {
    Map<String, dynamic> wmiDetails = {
      "AAA":
          "South Africa Audi South Africa made by Volkswagen of South Africa",
      "AAK": "FAW Vehicle Manufacturers SA (PTY) Ltd.",
      "AAM": "MAN Automotive (South Africa) (Pty) Ltd. includes VW Truck & Bus",
      "AAV": "Volkswagen of South Africa[17]",
      "ABJ": "Mitsubishi Fuso made by Daimler Trucks & Buses Southern Africa",
      "ACV": "Isuzu Motors South Africa 2018-",
      "AC5": "Hyundai Automotive South Africa (cars)",
      "ADD": "UD Trucks Southern Africa (Pty) Ltd",
      "ADM": "General Motors South Africa includes Isuzu through 2018",
      "ADN": "Nissan South Africa (Pty) Ltd",
      "ADR": "Renault Sandero made by Nissan South Africa (Pty) Ltd",
      "ADX": "Tata Automobile Corporation (SA) Ltd.",
      "AFA": "Ford Motor Company of Southern Africa & Samcor",
      "AFB": "Mazda BT-50 made by Ford Motor Company of Southern Africa",
      "AHH": "Hino South Africa",
      "AHM": "Honda Ballade made by Mercedes-Benz South Africa 1982–2000",
      "AHT": "Toyota South Africa Motors[17]",
      "BF9": "Kenya KIBO Motorcycles",
      "CL9": "Tunisia Wallyscar",
      "DA1": "DA4 Egypt Arab American Vehicles",
      "DAA": "Fiat Auto Egypt Industrial Co",
      "DAB": "BMW Egypt SKD",
      "DF9": "Morocco Laraki",
      "GA1":
          "Madagascar Renault /SOMACOA - Société Malgache de Construction Automobile",
      "J81": "Japan Chevrolet/Geo car made by Isuzu",
      "J87": "Pontiac/Asüna car made by Isuzu for GM Canada",
      "J8B": "J8C Chevrolet commercial trucks made by Isuzu",
      "J8D": "J8T GMC commercial trucks made by Isuzu",
      "J8Z": "Chevrolet pickup truck made by Isuzu",
      "JA3": "Mitsubishi car",
      "JA4": "Mitsubishi MPV/SUV",
      "JA7": "Mitsubishi truck",
      "JAA": "Isuzu truck",
      "JAB": "Isuzu car",
      "JAC": "Isuzu SUV",
      "JAE": "Acura SLX made by Isuzu",
      "JAL":
          "Isuzu commercial trucks & Chevrolet commercial trucks made by Isuzu 2016+ & Hino S-series truck made by Isuzu",
      "JAM": "Isuzu commercial trucks",
      "JB3": "Dodge car made by Mitsubishi Motors",
      "JB4": "Dodge MPV/SUV made by Mitsubishi Motors",
      "JB7": "Dodge truck made by Mitsubishi Motors",
      "JC0": "Ford brand cars made by Mazda",
      "JC1": "Fiat 124 Spider made by Mazda",
      "JC2": "Ford Courier made by Mazda",
      "JD1": "Daihatsu car",
      "JD2": "Daihatsu SUV",
      "JD4": "Daihatsu truck",
      "JDA": "Daihatsu",
      "JE3": "Eagle car made by Mitsubishi Motors",
      "JE4": "Mitsubishi",
      "JF1": "Subaru – Fuji Heavy Industries car",
      "JF2": "Subaru – Fuji Heavy Industries SUV",
      "JF3": "Subaru – Fuji Heavy Industries truck",
      "JF4": "Saab 9-2X made by Subaru",
      "JG1": "Chevrolet/Geo car made by Suzuki",
      "JG7": "Pontiac/Asuna car made by Suzuki for GM Canada",
      "JGC": "Chevrolet/Geo SUV made by Suzuki",
      "JGT": "GMC SUV made by Suzuki for GM Canada",
      "JH2": "Honda motorcycle/ATV",
      "JH3": "Honda ATV",
      "JH4": "Acura car",
      "JHA": "JHB Hino",
      "JHD": "JHF JHH Hino",
      "JHL": "Honda MPV/SUV[17]",
      "JHM": "Honda car[17]",
      "JJ3": "Chrysler car made by Mitsubishi Motors",
      "JK8": "Suzuki QUV620F UTV made by Kawasaki",
      "JKA": "JKB Kawasaki",
      "JKS": "Suzuki Marauder 1600/Boulevard M95 motorcycle made by Kawasaki",
      "JL5": "JL6 Mitsubishi FUSO Truck & Bus Corp",
      "JLF": "Mitsubishi FUSO Truck & Bus Corp",
      "JLS": "Sterling Trucks 360 made by Mitsubishi FUSO Truck & Bus Corp",
      "JM0": "Mazda for Oceania export",
      "JM1": "Mazda car",
      "JM2": "Mazda truck",
      "JM3": "Mazda MPV/SUV",
      "JM6": "Mazda[17]",
      "JM7": "Mazda",
      "JMA": "JMB Mitsubishi[17]",
      "JMF": "Mitsubishi",
      "JMY": "Mitsubishi",
      "JMZ": "Mazda for Europe export",
      "JN ": "Nissan[17]",
      "JN1": "Nissan car & Infiniti car",
      "JN3": "Nissan incomplete vehicle",
      "JN6": "Nissan truck",
      "JN8": "Nissan MPV/SUV & Infiniti SUV",
      "JNA": "Nissan Diesel/UD Trucks incomplete vehicle",
      "JNC": "Nissan Diesel/UD Trucks",
      "JNE": "Nissan Diesel/UD Trucks truck",
      "JNK": "Infiniti car",
      "JNR": "Infiniti SUV",
      "JNX": "Infiniti incomplete vehicle",
      "JP3": "Plymouth car made by Mitsubishi Motors",
      "JP4": "Plymouth MPV/SUV made by Mitsubishi Motors",
      "JP7": "Plymouth truck made by Mitsubishi Motors",
      "JPC": "Nissan Diesel/UD Trucks",
      "JR2": "Isuzu Oasis made by Honda",
      "JS ": "Suzuki[17]",
      "JS1":
          "Suzuki motorcycle & Kawasaki KLX400S/KLX400SR motorcycle made by Suzuki",
      "JS2": "Suzuki car",
      "JS3": "Suzuki SUV",
      "JSA": "Kawasaki KFX400 ATV made by Suzuki",
      "JSK": "Kawasaki KLX125/KLX125L motorcycle made by Suzuki",
      "JSL": "Kawasaki KFX400 ATV made by Suzuki",
      "JT ": "Toyota[17]",
      "JT2": "Toyota car",
      "JT3": "Toyota MPV/SUV",
      "JT4": "Toyota truck",
      "JT5": "Toyota incomplete vehicle",
      "JT6": "Lexus SUV",
      "JT8": "Lexus car",
      "JTD": "Toyota car",
      "JTE": "Toyota MPV/SUV",
      "JTF": "Toyota van/truck",
      "JTG": "Toyota MPV/bus",
      "JTH": "Lexus car",
      "JTJ": "Lexus SUV",
      "JTK": "Toyota car",
      "JTL": "Toyota SUV",
      "JTM": "Toyota SUV",
      "JTN": "Toyota car",
      "JW6": "Mitsubishi FUSO division of Mitsubishi Motors (through mid 2003)",
      "JY ": "Yamaha Motor[17]",
      "JY3": "Yamaha Motor 3-wheel ATV",
      "JY4": "Yamaha Motor 4-wheel ATV",
      "JYA": "Yamaha Motor motorcycles",
      "JYE": "Yamaha Motor snowmobile",
      "KF3": "Israel Merkavim",
      "KF6": "Automotive Industries, Ltd.",
      "KF9": " 004 Tomcar",
      "KLA": "South Korea Daewoo/GM Korea[17]",
      "KLT": " KLU Tata Daewoo",
      "KL1": "GM Daewoo/GM Korea Chevrolet car",
      "KL2": "Daewoo/GM Daewoo Pontiac",
      "KL3": "GM Daewoo/GM Korea Holden",
      "KL4": "GM Korea Buick",
      "KL5": "GM Daewoo Suzuki",
      "KL6": "GM Daewoo GMC",
      "KL7": "Daewoo GM Canada brands: Passport, Asuna (Pre-2000)",
      "KL8": "GM Daewoo/GM Korea Chevrolet car (Spark)",
      "KMA": "Asia Motors",
      "KME": "Hyundai commercial truck",
      "KMF": "Hyundai van & commercial truck & Bering Truck",
      "KMH": "Hyundai car[17]",
      "KMJ": "Hyundai bus & minibus",
      "KMT": "Genesis Motor car",
      "KMU": "Genesis Motor SUV",
      "KMY": "Daelim Motor Company, Ltd/DNA Motors Co., Ltd.",
      "KM4": "Hyosung Motors/S&T Motors/KR Motors",
      "KM8": "Hyundai SUV",
      "KNA": " KNC KNE Kia car[17]",
      "KND": "Kia SUV/MPV & Hyundai Entourage",
      "KNJ": "Ford Festiva & Aspire",
      "KNM":
          "Renault Samsung Motors & Nissan Rogue made by Renault Samsung Motors",
      "KPA": "SsangYong pickup",
      "KPB": "SsangYong car",
      "KPH": "Mitsubishi Precis",
      "KPT": "SsangYong SUV/MPV[17]",
      "L1C": "China Hubei Huawei Special-Purpose Automobile",
      "L2C": "Chery Jaguar Land Rover",
      "L5Y": "Znen Taizhou Zhongneng Motorcycle Co. Ltd.",
      "L6T": "Geely",
      "L8A": "Jinhua Youngman Automobile Manufacturing Co., Ltd.",
      "L8Y": "Zhejiang Jonway Motorcycle Manufacturing Co., Ltd.",
      "L9N": "Zhejiang Taotao Vehicles Co., Ltd.",
      "LA6": "King Long",
      "LA9": " LC0 BYD Auto",
      "LAL": "Sundiro Honda Motorcycle Co., Ltd.",
      "LB1": "Fujian Benz",
      "LB2": "Geely motorcycle",
      "LB3": "Geely",
      "LBB": "Qianjiang Motorcycle & Benelli",
      "LBE": "Beijing Hyundai",
      "LBP": "Chonqing Jianshe Yamaha Motor Co. Ltd.",
      "LBV": "BMW Brilliance",
      "LC0": "BYD Auto Industry Co. Ltd.",
      "LC2": "Changzhou Kwang Yang Motor Co., Ltd.",
      "LC6": "Changzhou Haojue Suzuki Motorcycle Co. Ltd.",
      "LCE":
          "CF Moto by Chunfeng Holding Group Hangzhou Motorcycles Manufacturing Co., Ltd.",
      "LCR": "Gonow",
      "LDC": "Dongfeng Peugeot-Citroën",
      "LDK": "FAW Bus (Dalian) Co., Ltd.",
      "LDN": "Soueast",
      "LDY": "Zhongtong Bus",
      "LE4":
          "Beijing Benz & Beijing Benz-Daimler Chrysler Automotive Co., Ltd.",
      "LEF": "JMC",
      "LET": "Jiangxi Isuzu",
      "LF3": "Lifan motorcycle",
      "LFB": "FAW Jilin",
      "LFM": "FAW Toyota",
      "LFN": "FAW Bus (Wuxi) Co., Ltd.",
      "LFP": "FAW Car",
      "LFV": "FAW-Volkswagen",
      "LGA": "Dongfeng Commercial Vehicle Co., Ltd. trucks",
      "LGB": "Dongfeng Nissan",
      "LGC": "Dongfeng Commercial Vehicle Co., Ltd. buses",
      "LGG": "Dongfeng Liuzhou Motor",
      "LGJ": "Dongfeng Fengshen (Aeolus)",
      "LGL": "Guilin Daewoo",
      "LGW": "Great Wall (Haval)",
      "LGX": "BYD Auto",
      "LGZ": "Guangzhou Denway Bus",
      "LH1": "FAW Haima",
      "LHG": "Guangzhou Honda",
      "LJ1": "JAC",
      "LJ8": "Zotye Auto",
      "LJC": "Jincheng Corporation",
      "LJD": "Dongfeng Yueda Kia",
      "LJN": "Zhengzhou Nissan",
      "LJS": "Yaxing Coach",
      "LJU": "Shanghai Maple Automobile & Kandi",
      "LJV": "Sinotruk Chengdu Wangpai Commercial Vehicle Co., Ltd.",
      "LJX": "JMC Ford",
      "LKC": "Changhe",
      "LKG": "Youngman Lotus Automobile Co., Ltd.",
      "LKL": "Higer Bus",
      "LKT": "Yunnan Lifan Junma Vehicle Co., Ltd. commercial vehicles",
      "LL3": "Xiamen Golden Dragon Bus Co. Ltd",
      "LL6": "GAC Mitsubishi",
      "LL8": "Jiangsu Linhai Yamaha Motor Co., Ltd.",
      "LLC": "Loncin Holdings",
      "LLN": "Qoros",
      "LLV": "Lifan",
      "LM6": "SWM (automobiles)",
      "LMG": "GAC Trumpchi",
      "LNB": "BAIC Motor",
      "LNP": "NAC MG UK Limited & Nanjing Fiat Automobile",
      "LNY": "Yuejin",
      "LPA": "Changan PSA (DS Automobiles)",
      "LPE": "BYD Auto",
      "LPS": "Polestar",
      "LRB": "SAIC General Motors Buick",
      "LRD": "Beijing Foton Daimler Automotive Co., Ltd. Auman trucks",
      "LRE": "SAIC General Motors Cadillac",
      "LRW": "Tesla",
      "LS5": "Changan Automobile & Changan Suzuki",
      "LS7": "JMC Heavy Duty Vehicle",
      "LSF": "SAIC Maxus & Shanghai Sunwin Bus Corporation",
      "LSG": "SAIC General Motors Chevrolet",
      "LSH": "SAIC Maxus",
      "LSJ": "SAIC MG & SAIC Roewe",
      "LSK": "SAIC Maxus",
      "LSV": "SAIC Volkswagen",
      "LSY": "Brilliance & Jinbei GM",
      "LTA": "ZX Auto",
      "LTN": "Soueast built Chrysler & Dodge vehicles",
      "LTV": "FAW Toyota (Tianjin)",
      "LUC": "Honda Automobile (China)",
      "LUD": "Dongfeng Nissan Diesel Motor Co Ltd",
      "LUX": "Dongfeng Yulon Motor Co. Ltd",
      "LVA": " LVB LVC Foton Motor",
      "LVF": "Changhe Suzuki",
      "LVG": "GAC Toyota",
      "LVH": "Dongfeng Honda",
      "LVM": "Chery Commercial Vehicle",
      "LVR": "Changan Mazda",
      "LVS": "Changan Ford & Changan Ford Mazda",
      "LVV": "Chery",
      "LVX": "Landwind",
      "LVY": "Volvo Cars Daqing factory",
      "LVZ": "DFSK Motor",
      "LWB": "Wuyang Honda Motorcycle (Guangzhou) Co., Ltd.",
      "LWL": "Qingling Isuzu",
      "LWV": "GAC Fiat Chrysler",
      "LXV": "Beijing Borgward Automotive Co., Ltd.",
      "LXY": "Chongqing Shineray Motorcycle Co., Ltd.",
      "LYB": "Weichai (Yangzhou) Yaxing Automobile Co., Ltd.",
      "LYM": "Zhuzhou Jianshe Yamaha Motorcycle Co., Ltd.",
      "LYV": "Volvo Cars Chengdu factory & Luqiao factory",
      "LZF": "SAIC Iveco Hongyan",
      "LZG": "Shaanxi Automobile Group Shacman Bus",
      "LZK": "Sinotruk (CNHTC) Huanghe bus",
      "LZS": "Zongshen",
      "LZU": "Guangzhou Isuzu Bus",
      "LZW": "SAIC GM Wuling",
      "LZY": "Yutong",
      "LZZ": "Sinotruk (CNHTC) Howo, Sitrak",
      "MA1": "India Mahindra",
      "MA3": "Maruti Suzuki India Limited",
      "MA6": "General Motors India Pvt. Ltd.",
      "MA7":
          "Hindustan Motors Ltd & Mitsubishi Motors models made by Hindustan Motors & Isuzu models made by Hindustan Motors",
      "MAH": "Fiat India Automobiles Pvt. Ltd",
      "MAJ": "Ford India",
      "MAK": "Honda Cars India",
      "MAL": "Hyundai Motor India",
      "MAN": "Eicher Polaris Multix",
      "MAT": "Tata Motors",
      "MB1": "Ashok Leyland Ltd",
      "MB8": "Suzuki Motorcycle India Limited",
      "MBF": "Royal Enfield",
      "MBH": "Nissan Pixo made by Maruti Suzuki India Limited",
      "MBJ": "Toyota Kirloskar Motor Pvt Ltd",
      "MBK": "MAN Trucks India Pvt. Ltd",
      "MBL": "Hero MotoCorp",
      "MBU": "Swaraj Vehicles Limited",
      "MBV": "Premier Automobiles Ltd",
      "MBX": "Piaggio India Piaggio Ape",
      "MBY": "Asia Motor Works Ltd",
      "MC1": "Force Motors Limited",
      "MC2": "Eicher Motors Limited",
      "MC4": "Dilip Chhabria Design Pvt Ltd",
      "MCA": "FCA India Automobiles Pvt. Ltd",
      "MCB": "General Motors India Pvt. Ltd.",
      "MCD": "Mahindra Two Wheelers",
      "MCG": "Atul Auto",
      "MCL": "International Cars And Motors Ltd",
      "MD2": "Bajaj Auto Ltd & KTM and Husqvarna models built by Bajaj",
      "MD6": "TVS Motor Company",
      "MD7": "LML Ltd including Genuine Scooter Company Stella",
      "MDE": "Kinetic Engineering Limited",
      "MDH": "Nissan Motor India Pvt Ltd",
      "MDT": "Kerala Automobiles Limited",
      "ME1": "India Yamaha Motor Pvt. Ltd",
      "ME3": "Royal Enfield",
      "ME4": "Honda Motorcycle and Scooter India",
      "ME9": "BUYMYEV TECHNOLOGY PVT LTD",
      "MEC": "Daimler India Commercial Vehicles Pvt. Ltd. BharatBenz",
      "MEE": "Renault India Private Limited",
      "MEG": "Harley-Davidson India",
      "MER": "Benelli",
      "MET": "Piaggio India Vespa",
      "MEX": "Škoda Auto Volkswagen India Pvt. Ltd. 2015 on",
      "MYH": "Ather Energy",
      "MZ7": "MG Motor India Pvt. Ltd.",
      "MZB": "Kia India Pvt. Ltd.",
      "MZD": "Classic Legends Private Limited – Jawa",
      "M3G": "Isuzu Motors India",
      "M6F": "UM Lohia Two Wheelers Private Limited",
      "MH1": "Indonesia PT Astra Honda Motor",
      "MH3": "PT Yamaha Indonesia Motor Mfg.",
      "MH4": "PT Kawasaki Motor Indonesia",
      "MHF": "PT Toyota Astra Motor",
      "MHK": "PT Astra Daihatsu Motor including Toyotas made by Astra Daihatsu",
      "MHL": "PT Mercedes Benz Indonesia",
      "MHR": "PT Honda Prospect Motor",
      "MHY": "PT Suzuki Indomobil Motor",
      "MJB": "GM Indonesia",
      "MK2": "Mitsubishi Motors Krama Yudha Indonesia",
      "MK3": "PT SGMW Motor Indonesia Wuling",
      "ML0": "Mitsubishi Motors (Thailand)",
      "ML5": "Kawasaki Motors Enterprise Co. Ltd. (Thailand)",
      "MLC": "Thai Suzuki Motor Co., Ltd.",
      "MLE": "Thai Yamaha Motor Co., Ltd.",
      "MLH": "Honda motorcycle",
      "MLY": "Harley-Davidson",
      "MM0": " MM6 MM7 Mazda (Ford-Mazda AAT plant)",
      "MM8": "Mazda (Ford-Mazda AAT plant)[18]",
      "MMA": " MMB Mitsubishi Motors (Thailand)[17]",
      "MMC": " MMD Mitsubishi Motors (Thailand)",
      "MMF": "BMW[19]",
      "MMH": "Tata[20]",
      "MMK": "Toyota (Toyota Auto Works plant)[21]",
      "MMM": "Chevrolet[22]",
      "MML": "MG",
      "MMR": "Subaru[23]",
      "MMS": "Suzuki[24]",
      "MMT": "Mitsubishi Motors (Thailand)[25]",
      "MMU": "Holden",
      "MNA": "Ford (Ford-Mazda AAT plant) for Australia/New Zealand export",
      "MNB":
          "Ford (Ford-Mazda AAT plant)[26] for other right-hand drive markets",
      "MNC": "Ford (Ford-Mazda AAT plant) for left-hand drive markets",
      "MNK": "Hino Motors Manufacturing Thailand Co Ltd",
      "MNT": "Nissan Motor Thailand",
      "MPA": "IMCT Isuzu Motors Company Thailand",
      "MPB": "Ford (FTM plant)[27]",
      "MP1": "IMCT Isuzu Motors Company Thailand",
      "MP2": "Mazda BT-50 pickup built by Isuzu Motors (Thailand) Co., Ltd.",
      "MP5": "Foton[28]",
      "MRH": "Honda car",
      "MR0": "Toyota (Ban Pho and Samrong plant)[29]",
      "MR1": "Toyota (Samrong plant) (Fortuner)",
      "MR2": "Toyota (Gateway plant)[30]",
      "MS0": "Myanmar SSS MOTORS Myanmar/Kia",
      "MS3": "Suzuki Myanmar Motor Co.,Ltd.",
      "MXV": "Kazakhstan IMZ-Ural Ural Motorcycles",
      "MX3": "Hyundai Trans Auto",
      "N3C": "Iran Kavir motor Company (Yektaz)",
      "N58": "Kavir motor Company (EURASIA)",
      "NAA": "Iran khodro Company",
      "NAD": "Saipa Diesel",
      "NAG": "Bahman Industrial Group",
      "NAP": "Pars Khodro",
      "NAS": "Pakistan Honda Atlas Cars Pakistan Ltd",
      "NG3": "Lucky Motor Corporation",
      "NLA": "Turkey Honda cars",
      "NLC": "Askam Kamyon Imalat Ve Ticaret A.S.",
      "NLH": "Hyundai Assan Otomotiv car/SUV",
      "NLJ": "Hyundai Assan Otomotiv van",
      "NLN": "Karsan Automotive Industry & Trade",
      "NLR": "Otokar",
      "NLT": "TEMSA",
      "NL1": "Togg",
      "NMA": "MAN Türkiye A.Ş.[17]",
      "NMB": "Mercedes-Benz Türk A.S.",
      "NMC": "BMC Otomotiv Sanayi ve Ticaret A.Ş.",
      "NMH": "Honda motorcycle",
      "NMT": "Toyota Motor Manufacturing Turkey",
      "NM0": "Ford Otosan",
      "NM1": "Oyak-Renault Oto Fab AS",
      "NM4": "Tofas (Turk Otomobil Fabrikasi AS)",
      "NNA": "Anadolu Isuzu",
      "PAB": "Philippines Isuzu Philippines Corporation",
      "PAD": "Honda Cars Philippines",
      "PE1": "Ford Motor Company Philippines",
      "PE3": "Mazda Philippines made by Ford Motor Company Philippines",
      "PL1": "Malaysia Proton",
      "PL8": "Hyundai/Inokom",
      "PLP": "Subaru",
      "PLZ": "Isuzu Malaysia",
      "PMH": "Honda car",
      "PML": "Hicom",
      "PM1": "BMW",
      "PM2": "Perodua",
      "PM9": "Bufori",
      "PMK": "Honda Boon Siew motorcycle",
      "PMN": "Modenas",
      "PMV": "Hong Leong Yamaha Motor Sdn. Bhd.",
      "PNA": "Naza/Kia/Peugeot",
      "PNV": "Volvo Cars",
      "PN1": " PN2 Toyota",
      "PN8": "Nissan",
      "PP1": "Mazda",
      "PP3": "Hyundai",
      "PPP": "Suzuki",
      "PPV": "Volkswagen",
      "PR8": "Ford",
      "PRA": "Sinotruk",
      "PRH": "Chery",
      "LFA": "Taiwan Ford Lio Ho Motor Co Ltd old designation",
      "LM1": " LM4 Tai Ling Motor Co Ltd old designation",
      "LPR": "Yamaha Motor Taiwan Co. Ltd. old designation",
      "RF3": "Aeon Motor",
      "RF5": "Yulon Motor Co Ltd",
      "RFB": "Kymco",
      "RFC": "Taiwan Golden Bee",
      "RFD": "Tai Ling Motor Co Ltd new designation",
      "RFG": "SYM Motors",
      "RFV":
          "PGO Scooters including Genuine Scooter Company models made by PGO",
      "RGS": "Kawasaki made by Kymco",
      "RHA": "Ford Lio Ho Motor Co Ltd new designation",
      "RK7":
          "Kawasaki ATV made by Tai Ling Motor Co Ltd (rebadged Suzuki ATV) new designation",
      "RKJ": "Prince Motors Taiwan",
      "RKL": "Kuozui Motors (Toyota)",
      "RKM": "China Motor Corporation",
      "RKR": "Honda Taiwan",
      "RL0": "Vietnam Ford Vietnam",
      "RL4": "Toyota Motor Vietnam",
      "RLA": "Vina Star Motors Corp. – Mitsubishi",
      "RLC": "Yamaha Motor Vietnam Co. Ltd.",
      "RLE": "Isuzu Vietnam Co.",
      "RLH": "Honda Vietnam Co. Ltd.",
      "RLL": "VinFast SUV",
      "RLM": "Mercedes-Benz Vietnam",
      "RLV": "Vietnam Precision Industrial CO., Ltd. Can-Am DS 70 & DS 90",
      "RP8": "Piaggio Vietnam Co. Ltd.",
      "R4N": "Hong Kong Elyx Smart Technology Holdings (Hong Kong) Ltd.",
      "Eur": "ope",
      "SA9": "United Kingdom < 500 units Morgan Motor Company",
      "SAA": "United Kingdom Austin",
      "SAB": "Optare",
      "SAD": "Jaguar SUV",
      "SAF": "ERF",
      "SAH": "Honda made by Austin Rover Group",
      "SAJ": "Jaguar",
      "SAL": "Land Rover[17]",
      "SAM": "Morris",
      "SAR": "Rover & MG Rover Group[17]",
      "SAT": "Triumph car[17]",
      "SAX": "Austin Rover Group including Sterling Cars",
      "SAY": "Norton Motorcycles",
      "SAZ": "Freight Rover",
      "SBB": "Leyland Vehicles",
      "SBC": "Iveco Ford Truck",
      "SBJ": "Leyland Bus",
      "SBL": "Leyland Motors & Leyland DAF",
      "SBM": "McLaren Group[17]",
      "SBS": "Scammell",
      "SBV": "Kenworth & Peterbilt trucks made by Leyland Trucks",
      "SB1": "Toyota Manufacturing UK[17]",
      "SCA": "Rolls-Royce Motor Cars & Rolls-Royce Motors car",
      "SCB": "Bentley Motors Limited",
      "SCC": "Lotus Cars Limited[17]",
      "SCE": "DeLorean",
      "SCF": "Aston Martin Lagonda Limited[17]",
      "SCG": "Triumph Engineering original Triumph Motorcycle company",
      "SCK": "Ifor Williams Trailers",
      "SCR":
          "London Electric Vehicle Company & London Taxi Company & London Taxis International",
      "SCV": "Volvo Truck & Bus",
      "SC6": "INEOS Automotive[17]",
      "SDB": "Talbot Motor Company",
      "SDF": "Dodge Trucks – UK 1981–1984",
      "SDG": "Renault Trucks Industries 1985–1992",
      "SDK": "Caterham Cars",
      "SDL": "TVR",
      "SDP": "MG Motor NAC MG UK & MG Motor UK",
      "SD7": "Aston Martin SUVs",
      "SED": "IBC Vehicles (Isuzu Bedford Company)",
      "SEG": "Dennis Eagle",
      "SEY": "LDV Group",
      "SFA": "Ford of Britain",
      "SFD": "Dennis",
      "SFE": "Alexander Dennis",
      "SFN": "Foden",
      "SFZ": "Tesla Roadster made by Lotus",
      "SGD": "Swift Group LTD.",
      "SHH": "Honda UK Manufacturing car[17]",
      "SHS": "Honda UK Manufacturing SUV[17]",
      "SJA": "Bentley SUV",
      "SJK": "Nissan Motor Manufacturing UK[17] Infiniti",
      "SJN": "Nissan Motor Manufacturing UK[17] Nissan",
      "SKA": "Vauxhall Motors",
      "SKF": "Bedford Vehicles",
      "SLA": "Rolls-Royce Motor Cars SUV",
      "SLP": "JC Bamford Excavators",
      "SLV": "Volvo Bus",
      "SMT": "Triumph Motorcycles Ltd current Triumph Motorcycle company",
      "SNE": "East Germany Wartburg",
      "SNT": "Trabant",
      "SNZ": "MZ Motorrad- und Zweiradwerk",
      "SUA": "Poland Sanocka Fabryka Autobusow Sfa / Autosan",
      "SUD": "Wielton",
      "SUF": "Fabryka Samochodów Małolitrażowych",
      "SUJ": "Jelcz",
      "SUL": "FSC Lublin Automotive Factory",
      "SUM": "Metal-Fach Sp. z o.o.",
      "SUN": "FSD [pl]",
      "SUP": "Fabryka Samochodow Osobowych",
      "SUU": "Solaris Bus & Coach",
      "SZA": "Scania Production Slupsk",
      "TAM": "Switzerland Mowag",
      "TAP": "Polaris Europe (based in Switzerland)",
      "TCC": "Micro Compact Car[17] (until 5/99)",
      "TEB":
          "Bucher Municipal including Johnston Sweepers of the UK (owned by Bucher Municipal of Switzerland)",
      "TK9": " SL5 Czech Republic SOR Libchavy",
      "TLJ": "Jawa Moto",
      "TMA": "Hyundai Motor Manufacturing Czech car[17]",
      "TMB": "Škoda Auto AS[17]",
      "TMC": "Hyundai Motor Manufacturing Czech SUV",
      "TMK": "Karosa",
      "TMP": "Škoda Ostrov",
      "TMT": "Tatra car",
      "TNA": "Avia/Daewoo Avia",
      "TNT": " TNU Tatra trucks",
      "TRA": "Hungary Ikarus Bus",
      "TRU": "Audi[17]",
      "TSM": "Suzuki[17]",
      "TW1": "Portugal Toyota Caetano Portugal",
      "TW3": "Renault Portuguesa SARL",
      "TW7": "Mini Moke made by British Leyland & Austin Rover",
      "TW8": "General Motors De Portugal Lda",
      "TWG": "Salvador Caetano",
      "TX5": "Mini Moke made by Cagiva",
      "TYA": "Mitsubishi Fuso Truck and Bus Corp.",
      "TYB": "Mitsubishi Fuso Truck and Bus Corp.",
      "U5Y": "Slovakia Kia Motors Slovakia car[17]",
      "U6Y": "Kia Motors Slovakia SUV",
      "ULA":
          "Denmark ASA-LIFT: Vegetable Technology Specialist (Agricultural Machinery)",
      "UU1": "Romania Dacia[17]",
      "UU2": "Oltcit",
      "UU3": "ARO",
      "UU5": "Rocar",
      "UU6": "Daewoo Romania",
      "UU7": "Euro Bus Diamond",
      "UU9": "Astra Bus",
      "UZT": "UTB (Uzina de Tractoare Brașov)",
      "VA0": "Austria ÖAF[17]",
      "VAG": "S:teyr-Daimler-Puch Steyr Trucks",
      "VBK": ":Fisker Inc. (Fisker Ocean) made by Magna Steyr",
      "VF1": "Renault Trucks[17]",
      "VF3": "Peugeot[17]",
      "VF4": "Talbot[17]",
      "VF5": "Iveco Unic[17]",
      "VF6": "Renault Trucks[17]",
      "VF7": "Citroën[17]",
      "VF8": "Matra/Talbot/Simca[17]",
      "VF9": " 607 Mathieu Fayat Group",
      "VFA": "Alpine",
      "VG5": "MBK & Yamaha Motor",
      "VG6":
          "Renault Trucks & Mack Trucks medium duty trucks made by Renault Trucks",
      "VG7": ", VG8 Renault Trucks",
      "VGA": "Peugeot Motocycles",
      "VJ1": "Heuliez Bus",
      "VK8": "Venturi Automobiles",
      "VL4": "Bluecar",
      "VLU": "Scania Production Angers",
      "VMK": "Renault Sport Spider",
      "VN1": "Renault SOVAB",
      "VNE": "Iveco Bus",
      "VNK": "Toyota Motor Manufacturing France",
      "VNV": "Nissan",
      "VR1": "DS Automobiles",
      "VR3": "Peugeot",
      "VR7": "Citroën",
      "VPS": "MLT Automotive",
      "VXE": "Opel Automobile Gmbh/Vauxhall van",
      "VXK": "Opel Automobile Gmbh/Vauxhall car/SUV",
      "VS1": "Spain Pegaso",
      "VS5": "Renault España",
      "VS6": "Ford Espana",
      "VS7": "Citroën",
      "VS8": "Peugeot",
      "VSC": "Mercedes-Benz Espana SA (Vitoria)",
      "VSE": "Santana Motor",
      "VSK":
          "Nissan Motor Iberica SA, Nissan passenger car/MPV/van/SUV/pickup & Ford Maverick 1993–1999",
      "VSS": "SEAT[17]",
      "VSX": "Opel Automobile Espana,SA",
      "VTD": "Montesa Honda Honda Montesa motorcycle models",
      "VTH": "Derbi",
      "VTL":
          "Yamaha Motor España SA & Yamaha Sociedad Española de Motocicletas",
      "VTM": "Montesa Honda Honda motorcycle models",
      "VTR": "Gas Gas",
      "VTT": "Suzuki Motor España Motorcycle",
      "VV9": "Tauro Sport Auto",
      "VWA": "Nissan Vehiculos Industriales SA, Nissan Commercial Vehicles",
      "VX1": "Yugoslavia/Serbia Zastava Automobiles",
      "V31": "Croatia Tvornica Autobusa Zagreb (TAZ)",
      "V39": " AB8 Rimac Automobili",
      "WAC": "Germany Audi/Porsche RS 2 Avant",
      "WAG": "Neoplan[17]",
      "WAU": "Audi car[17]",
      "WAP": "Alpina[17]",
      "WBA": "BMW car[17]",
      "WBS": "BMW M car[17]",
      "WBX": "BMW SUV[17]",
      "WBY": "BMW i car",
      "WB1": "BMW Motorrad Motorcycle",
      "WB3": "BMW Motorrad Motorcycles made in India",
      "WB4": "BMW Motorrad Motorscooters made in China",
      "WB5": "BMW i SUV",
      "WCD":
          "Freightliner Sprinter (van with more than 3 rows of seats) 2008–2019",
      "WD0": "Dodge Sprinter truck (cargo van with 1 row of seats) 2005–2009",
      "WD1":
          "Freightliner Sprinter 2002 & Sprinter (Dodge or Freightliner) 2003–2005 incomplete vehicle",
      "WD2":
          "Freightliner Sprinter 2002 & Sprinter (Dodge or Freightliner) 2003–2005 truck (cargo van with 1 row of seats)",
      "WD3":
          "Mercedes-Benz truck (cargo van with 1 row of seats) (North America)",
      "WD4":
          "Mercedes-Benz MPV (van with 2 or 3 rows of seats) (North America)",
      "WD5":
          "Freightliner Sprinter 2002 & Sprinter (Dodge or Freightliner) 2003–2005 MPV (van with 2 or 3 rows of seats)",
      "WD6": "Freightliner Unimog truck",
      "WD7": "Freightliner Unimog incomplete vehicle",
      "WD8": "Dodge Sprinter MPV (van with 2 or 3 rows of seats) 2005–2009",
      "WDA": "Mercedes-Benz incomplete vehicle (North America)",
      "WDB": "Mercedes-Benz & Maybach[17]",
      "WDC": "Mercedes-Benz SUV[17]",
      "WDD": "Mercedes-Benz car",
      "WDF":
          "Mercedes-Benz van (French & Spanish built models – Citan & Vito & X-Class)",
      "WDP": "Freightliner Sprinter incomplete vehicle 2005–2019",
      "WDR":
          "Freightliner Sprinter MPV (van with 2 or 3 rows of seats) 2005–2019",
      "WDW": "Dodge Sprinter (van with more than 3 rows of seats) 2008–2009",
      "WDX": "Dodge Sprinter incomplete vehicle 2005–2009",
      "WDY":
          "Freightliner Sprinter truck (cargo van with 1 row of seats) 2005–2019",
      "WDZ":
          "Mercedes-Benz (van with more than 3 rows of seats) (North America)",
      "WEB": "EvoBus Mercedes-Benz buses[17]",
      "WEL": "e.GO Mobile AG",
      "WF0": "Ford of Europe[17]",
      "WF1": "Merkur",
      "WJM": "Iveco/Iveco Magirus",
      "WJR": "Irmscher[17]",
      "WKK": "Setra & Karl Kässbohrer Fahrzeugwerke[17]",
      "WMA": "MAN[17]",
      "WME": "Smart[17] (from 5/99)",
      "WMW": "Mini car[17]",
      "WMX":
          "Mercedes-AMG used for Mercedes-Benz SLS AMG & Mercedes-AMG GT (not used in North America)",
      "WMZ": "Mini SUV",
      "WNA": "Next.e.GO Mobile SE",
      "WP0": "Porsche car[17]",
      "WP1": "Porsche SUV[17]",
      "WS5": "StreetScooter",
      "WUA": "Audi Sport GmbH & Quattro GmbH car[17]",
      "WU1": "Audi Sport GmbH SUV",
      "WVG": "Volkswagen SUV[17]",
      "WVM": "Arbeitsgemeinschaft VW-MAN",
      "WVP": "Viseon Bus",
      "WVW": "Volkswagen car[17]",
      "WV1": "Volkswagen Commercial Vehicles[17]",
      "WV2": "Volkswagen Commercial Vehicles[17]",
      "WZ1": "Toyota Supra Fifth generation",
      "W04": "Buick Regal & Buick Cascada",
      "W06": "Cadillac Catera",
      "W08": "Saturn Astra",
      "W09": " B16 Brabus",
      "W0L": "Adam Opel AG/Vauxhall[17] & Holden",
      "W0S": "Opel Special Vehicles[17]",
      "W0V": "Opel Automobile Gmbh/Vauxhall & Holden",
      "W1A": "Smart",
      "W1H": "Freightliner Econic",
      "W1K": "Mercedes-Benz car",
      "W1N": "Mercedes-Benz SUV",
      "W1T": "Mercedes-Benz truck",
      "W1V": "Mercedes-Benz van",
      "W1W":
          "Mercedes-Benz MPV (van with 2 or 3 rows of seats) (North America)",
      "W1X": "Mercedes-Benz incomplete vehicle (North America)",
      "W1Y":
          "Mercedes-Benz truck (cargo van with 1 row of seats) (North America)",
      "W1Z":
          "Mercedes-Benz (van with more than 3 rows of seats) (North America)",
      "W2W": "Freightliner Sprinter MPV (van with 2 or 3 rows of seats)",
      "W2X": "Freightliner Sprinter incomplete vehicle",
      "W2Y": "Freightliner Sprinter truck (cargo van with 1 row of seats)",
      "W2Z": "Freightliner Sprinter (van with more than 3 rows of seats)",
      "XBB": "Bulgaria Great Wall Motors/Litex Motors AD",
      "XL9": " 363 Spyker Cars",
      "XLB": "Volvo Car B.V./NedCar B.V. (Volvo Cars)",
      "XLE": "Scania Nederland B.V.",
      "XLR": "DAF Trucks[17] & Leyland DAF",
      "XLV": "DAF Bus",
      "XMC": "NedCar B.V. Mitsubishi Motors",
      "XMG": "VDL Bus International",
      "XNC": "NedCar B.V. Mitsubishi Motors (Colt CZC convertible)",
      "XNL": "VDL Bus & Coach",
      "XP7": "Tesla Europe (based in the Netherlands)",
      "XTA": "Russia AvtoVAZ[17]",
      "XTB": "AZLK[17]",
      "XTC": "KAMAZ",
      "XTF": "GolAZ",
      "XTH": "GAZ",
      "XTT": "UAZ",
      "XTY": "LiAZ",
      "XU1": "UAZ Special Purpose Vehicles",
      "XUF": "General Motors Russia",
      "XUU": "Chevrolet made by Avtotor",
      "XW7": "Toyota Motor Manufacturing Russia",
      "XW8": "Volkswagen Group Rus",
      "XWE": "Hyundai Motor Company & Kia made by Avtotor",
      "X1E": "KAvZ",
      "X1M": "PAZ",
      "X4X": "BMW made by Avtotor",
      "X7L": "Renault Russia",
      "X8J": "IMZ-Ural Ural Motorcycles",
      "X96": "GAZ",
      "X9F": "Ford Motor Company ZAO",
      "X9L": "GM-AvtoVAZ",
      "X9P": "Volvo Vostok ZAO Volvo Trucks",
      "X9X": "Great Wall Motors IMS Avtotrade-12 LLC",
      "Z6F": "Ford Sollers",
      "Z8N": "Nissan Manufacturing Rus",
      "Z8T": "PCMA Rus",
      "Z94": "Hyundai Motor Manufacturing Rus",
      "Z9M": "Mercedes-Benz Trucks Vostok",
      "XWB": "Uzbekistán UzDaewoo GM Uzbekistan Ravon",
      "Y6D": "Ukraine ZAZ",
      "Y6J": "Bogdan group",
      "Y6U": "Škoda Auto made by Eurocar",
      "Y7B": "Bogdan group",
      "Y7C": "Great Wall Motors KrASZ",
      "YAR":
          "Belgium Toyota Motor Europe (based in Belgium) used for Toyota ProAce & Toyota ProAce City",
      "YB3": "Volvo Trucks",
      "YB6": "Jonckheere",
      "YC1": "Honda",
      "YE2": "Van Hool[17]",
      "YH2": "Finland Lynx (snowmobile)",
      "YH4": "Fisker Automotive (Fisker Karma) built by Valmet Automotive",
      "YK1": "Saab[17] built by Valmet Automotive",
      "YK7": "Sisu Auto",
      "YS2": "Sweden Scania, Södertälje[17] truck",
      "YS3": "Saab[17]",
      "YS4": "Scania, Katrineholm[17] bus",
      "YSC": "Cadillac BLS built by Saab",
      "YSM": "Polestar",
      "YT9": " 007 Koenigsegg Automotive AB[31]",
      "YTN": "Saab NEVS",
      "YU7": "Husaberg Swedish built models",
      "YV1": "Volvo Cars car[17]",
      "YV2": "Volvo Trucks[17]",
      "YV3": "Volvo Buses[17]",
      "YV4": "Volvo Cars SUV",
      "YV5": "Volvo Trucks incomplete vehicle",
      "YYC": "Norway Think Nordic",
      "ZA9": " A12 Italy Lamborghini through mid 2003",
      "ZAA": "Autobianchi",
      "ZAC": "Jeep and Dodge Hornet",
      "ZAM": "Maserati car[17]",
      "ZAP": "Piaggio and Vespa and Gilera[32]",
      "ZAR": "Alfa Romeo car[17] & Nissan Cherry Europe",
      "ZAS": "Alfa Romeo SUV 2018-",
      "ZBB": "Gruppo Bertone",
      "ZBN": "Benelli",
      "ZBW": "Rayton-Fissore Magnum",
      "ZC2": "Chrysler TC by Maserati",
      "ZC6": "Effedi Veicoli Commerciali",
      "ZCF": "Iveco[17]",
      "ZCG": "Cagiva & MV Agusta",
      "ZD0": "Yamaha Motor Italia SpA & Belgarda SpA",
      "ZD3": "Betamotor S.p.A.",
      "ZD4": "Aprilia",
      "ZDC": "Honda Italia Industriale S.p.A.",
      "ZDM": "Ducati Motor Holding",
      "ZDT": "De Tomaso Modena SpA",
      "ZDY": "Cacciamali",
      "ZE8": "Bremach",
      "ZES": "Bimota",
      "ZF4": "Qvale",
      "ZFA": "Fiat car[17] Also Fiat Fullback",
      "ZFB": "Fiat MPV/SUV",
      "ZFC": "Ram 1200",
      "ZFF": "Ferrari[17]",
      "ZFM": "Fantic Motor",
      "ZFR": "Pininfarina",
      "ZGA": "Iveco Bus[17]",
      "ZGU": "Moto Guzzi",
      "ZHU": "Husqvarna Motorcycles Under Cagiva ownership",
      "ZHW": "Lamborghini car[17] from mid 2003",
      "ZJM": "Malaguti",
      "ZJN": "Innocenti",
      "ZJT": "Italjet",
      "ZKH": "Husqvarna Motorcycles Srl Under BMW ownership",
      "ZK5": "Hyundai Automobili Italia Importazioni",
      "ZLA": "Lancia[17]",
      "ZLM": "Moto Morini srl",
      "ZLV": "Laverda",
      "ZN0": "SWM Motorcycles S.r.l.",
      "ZN3": "Iveco Defence",
      "ZN6": "Maserati SUV",
      "ZNN": "Energica Motor Company",
      "ZPB": "Lamborghini SUV",
      "ZPY": "DR Automobiles",
      "ZZ1": "Slovenia Tomos motorcycle",
      "1A4": " 1A8 United States Chrysler brand MPV/SUV 2006–2009 only",
      "1AC": "American Motors Corporation MPV",
      "1AF": "American LaFrance truck",
      "1AM": "American Motors Corporation car & Renault Alliance 1983 only",
      "1B3": "Dodge[17] car 1981–2011",
      "1B4": "Dodge MPV/SUV 1981–2002",
      "1B6": "Dodge incomplete vehicle 1981–2002",
      "1B7": "Dodge truck 1981–2002",
      "1B9": " 133 Buell Motorcycle Company through mid 1995",
      "1BA": "Blue Bird Corporation bus",
      "1BB": "Blue Bird Wanderlodge MPV",
      "1BD": "Blue Bird Corporation incomplete vehicle",
      "1BL": "Balko, Inc. from Ladysmith, WI",
      "1C3": "Chrysler brand[17] car 1981–2011",
      "1C4": "Chrysler brand MPV 1990–2005",
      "1C6": "Chrysler Group (all brands) truck 2012–",
      "1C8": "Chrysler brand MPV 2001–2005",
      "1C9": " 291 CX Automotive",
      "1CM": "Checker Motors Corporation",
      "1CU":
          "Cushman Haulster (Cushman division of Outboard Marine Corporation)",
      "1CY": "Crane Carrier Company",
      "1D3": "Dodge truck 2002–2009",
      "1D4": "Dodge MPV/SUV 2003–2011 only",
      "1D7": "Dodge truck 2002–2011",
      "1D8": "Dodge MPV/SUV 2003–2009 only",
      "1F ": "Ford[17]",
      "1F1": "Ford SUV – limousine (through 2009)",
      "1F6": "Ford stripped chassis made by Detroit Chassis LLC",
      "1F9": " ST2 Seagrave",
      "1FA": "Ford car",
      "1FB": "Ford (van with more than 3 rows of seats)",
      "1FC": "Ford stripped chassis made by Ford",
      "1FD": "Ford incomplete vehicle",
      "1FM": "Ford MPV/SUV",
      "1FT": "Ford truck",
      "1FU": " 1FV Freightliner Trucks",
      "1G ": "General Motors[17]",
      "1G0": "Opel car 2007–2017",
      "1G1": "Chevrolet car",
      "1G2": "Pontiac car",
      "1G3": "Oldsmobile car",
      "1G4": "Buick car[33]",
      "1G5": "GMC MPV/SUV 1981–1986",
      "1G6": "Cadillac car",
      "1G7": "Pontiac car only sold by GM Canada",
      "1G8": "Saturn car 1991–2010",
      "1G9": " 495 Google & Waymo",
      "1GA": "Chevrolet (van with more than 3 rows of seats)",
      "1GB": "Chevrolet incomplete vehicles[33]",
      "1GC": "Chevrolet truck",
      "1GD": "GMC incomplete vehicles[33]",
      "1GE": "Cadillac incomplete vehicle",
      "1GF": "Flxible bus",
      "1GG": "Isuzu pickup trucks made by GM",
      "1GH": "Holden Acadia 2019–2020",
      "1GJ": "GMC (van with more than 3 rows of seats) 1987–",
      "1GK": "GMC MPV/SUV 1987–",
      "1GM": "Pontiac MPV",
      "1GN": "Chevrolet MPV/SUV 1987-",
      "1GT": "GMC truck",
      "1GY": "Cadillac SUV",
      "1HA": "Chevrolet incomplete vehicles made by Navistar International",
      "1HD": "Harley-Davidson",
      "1HF": "Honda motorcycle/ATV/UTV",
      "1HG": "Honda[17] car made by Honda of America Mfg. in Ohio",
      "1HS": "International Trucks & Caterpillar Trucks truck",
      "1HT":
          "International Trucks & Caterpillar Trucks & Chevrolet Silverado 4500HD, 5500HD, 6500HD incomplete vehicle",
      "1HV": "IC Bus incomplete bus",
      "1J4": "Jeep[17] SUV 1989–2011 (using Chrysler-style VIN structure)",
      "1J7": "Jeep truck 1989–1992 (using Chrysler-style VIN structure)",
      "1J8": "Jeep SUV 2002–2011 (using Chrysler-style VIN structure)",
      "1JC": "Jeep SUV 1981–1988 (using AMC-style VIN structure)",
      "1JT": "Jeep truck 1981–1988 (using AMC-style VIN structure)",
      "1JU": "Marmon Motor Company",
      "1L ": "Lincoln[17]",
      "1L1": "Lincoln car – limousine",
      "1L9": " 234 Laforza",
      "1LJ": "Lincoln incomplete vehicle",
      "1LN": "Lincoln car",
      "1M0": "John Deere Gator",
      "1M1": " 1M2 Mack Trucks",
      "1M8": "Motor Coach Industries",
      "1M9": " 682 Mosler Automotive",
      "1MB": "Mercedes-Benz Truck Co.",
      "1ME": "Mercury car[17]",
      "1MR":
          "Continental Mark VI & VII 1981–1985 & Continental sedan[17] 1982–1985",
      "1N4": "Nissan car",
      "1N6": "Nissan truck",
      "1N9": " 013 Neoplan USA",
      "1NK": "Kenworth incomplete vehicle",
      "1NP": "Peterbilt incomplete vehicle",
      "1NX": "Toyota car made by NUMMI",
      "1P3": "Plymouth car",
      "1P4": "Plymouth MPV/SUV",
      "1P9": " 213 Panoz",
      "1S9": " 098 Scania AB Scania CN112 bus made in Orange, CT",
      "1T7": " 1T8 Thomas Built Buses",
      "1T9": " 899 Tomcar USA",
      "1TU": "Transportation Manufacturing Corporation",
      "1UT": "Jeep DJ made by AM General",
      "1V1": "Volkswagen truck",
      "1V2": "Volkswagen SUV",
      "1V9": " 048 Vector Aeromotive",
      "1VH": "Orion Bus Industries",
      "1VW": "Volkswagen car[17]",
      "1WU": "White truck",
      "1WV": " 1WW Winnebago Industries",
      "1WX": " 1WY White incomplete vehicle",
      "1XK": "Kenworth truck",
      "1XM": "Renault Alliance/GTA/Encore 1984–1987",
      "1XP": "Peterbilt truck",
      "1Y1": "Chevrolet/Geo car made by NUMMI",
      "1YJ": "Rokon International, Inc.",
      "1YV": "Mazda[17]",
      "1Z3": " 1Z7 Mitsubishi Raider",
      "1Z9": " 332 Oshkosh Specialty Vehicles LLC",
      "1ZV": "Ford made by AutoAlliance International",
      "1ZW": "Mercury made by AutoAlliance International",
      "10R": "E-Z-GO",
      "10T": "Oshkosh Corporation",
      "12A": "Avanti",
      "137": "AM General Hummer & Hummer H1",
      "15G": "Gillig bus",
      "16X": "Vixen 21 motorhome",
      "17N": "John Deere incomplete vehicle (RV chassis)",
      "19U": "Acura[17] car made by Honda of America Mfg. in Ohio",
      "19V": "Acura car made by Honda Manufacturing of Indiana",
      "19X": "Honda car made by Honda Manufacturing of Indiana",
      "2A3": "Canada Imperial",
      "2A4": " 2A8 Chrysler brand MPV/SUV 2006–2011 only",
      "2AY": " 2AZ Hino",
      "2B1": "Orion Bus Industries",
      "2B3": "Dodge[17] car 1981–2011",
      "2B4": "Dodge MPV 1981–2002",
      "2B5": "Dodge (van with more than 3 rows of seats) 1981–2002",
      "2B6": "Dodge incomplete vehicle 1981–2002",
      "2B7": "Dodge truck 1981–2002",
      "2BC": "Jeep Wrangler (YJ) 1987–1988 (using AMC-style VIN structure)",
      "2BP": "Ski-Doo",
      "2BV": "Can-Am & Bombardier ATV",
      "2BW": "Can-Am Commander E LSV",
      "2BX": "Can-Am Spyder",
      "2BZ": "Can-Am Freedom Trailer for Can-Am Spyder",
      "2C1": "Geo/Chevrolet car made by CAMI Automotive",
      "2C3": "Chrysler brand[17] car 1981–2011",
      "2C4": "Chrysler brand MPV/SUV 2000–2005",
      "2C7": "Pontiac car made by CAMI Automotive only sold by GM Canada",
      "2C8": "Chrysler brand MPV/SUV 2001–2005",
      "2C9": " 145 Campagna Motors",
      "2CC": "American Motors Corporation MPV",
      "2CG": "Asüna/Pontiac SUV made by CAMI Automotive only sold by GM Canada",
      "2CK":
          "GMC Tracker SUV made by CAMI Automotive only sold by GM Canada 1990–1991 only",
      "2CM": "American Motors Corporation car",
      "2CN": "GMC Terrain SUV made by CAMI Automotive 2010–2011 only",
      "2D4": "Dodge MPV 2003–2011 only",
      "2D6": "Dodge incomplete vehicle 2003",
      "2D7": "Dodge truck 2003",
      "2D8": "Dodge MPV 2003–2011 only",
      "2DG": "Ontario Drive & Gear",
      "2E3": "Eagle car 1989–1997 (using Chrysler-style VIN structure)",
      "2E4": "Lancia MPV",
      "2F ": "Ford[17]",
      "2FA": "Ford car",
      "2FM": "Ford MPV/SUV",
      "2FT": "Ford truck",
      "2FU": " 2FV Freightliner Trucks",
      "2FW": "Sterling Trucks truck",
      "2FY": "New Flyer",
      "2FZ": "Sterling Trucks incomplete vehicle",
      "2Gx": "General Motors[17]",
      "2G0": "GMC (van with more than 3 rows of seats) 1981–1986",
      "2G1": "Chevrolet",
      "2G2": "Pontiac",
      "2G3": "Oldsmobile car",
      "2G4": "Buick",
      "2G5": "GMC MPV 1981–1986",
      "2G6": "Cadillac",
      "2G7": "Pontiac car only sold by GM Canada",
      "2G8": "Chevrolet MPV 1981–1986",
      "2G9": "Gnome Homes",
      "2GA": "Chevrolet (van with more than 3 rows of seats)",
      "2GB": "Chevrolet incomplete vehicles",
      "2GC": "Chevrolet truck",
      "2GD": "GMC incomplete vehicles",
      "2GE": "Cadillac incomplete vehicle",
      "2GH": "GMC GM New Look bus & GM Classic series bus",
      "2GJ": "GMC (van with more than 3 rows of seats) 1987–",
      "2GK": "GMC MPV/SUV 1987–",
      "2GN": "Chevrolet MPV/SUV 1987-",
      "2GT": "GMC truck",
      "2HG": "Honda car made by Honda of Canada Manufacturing",
      "2HH": "Acura car made by Honda of Canada Manufacturing",
      "2HJ": "Honda truck made by Honda of Canada Manufacturing",
      "2HK": "Honda MPV/SUV made by Honda of Canada Manufacturing",
      "2HM": "Hyundai",
      "2HN": "Acura SUV made by Honda of Canada Manufacturing",
      "2HS": "International Trucks truck",
      "2HT": "International Trucks incomplete vehicle",
      "2J4":
          "Jeep Wrangler (YJ) 1989–1992 (using Chrysler-style VIN structure)",
      "2L1": "Lincoln incomplete vehicle – limo",
      "2L9": "Les Contenants Durabac",
      "2LJ": "Lincoln incomplete vehicle – hearse",
      "2LM": "Lincoln SUV",
      "2LN": "Lincoln car[17]",
      "2M1": " 2M2 Mack Trucks",
      "2ME": "Mercury car[17]",
      "2MG": "Motor Coach Industries (Produced from Sept. 1, 2008 on)",
      "2MR": "Mercury MPV",
      "2NK": "Kenworth incomplete vehicle",
      "2NP": "Peterbilt incomplete vehicle",
      "2NV": "Nova Bus",
      "2P3": "Plymouth car",
      "2P4": "Plymouth MPV 1981–2000",
      "2P5": "Plymouth (van with more than 3 rows of seats) 1981–1983",
      "2P9": " 001 Prevost 1981–1995",
      "2PC": "Prevost 1996-",
      "2S2": "Suzuki car made by CAMI Automotive",
      "2S3": "Suzuki SUV made by CAMI Automotive",
      "2T1": "Toyota car",
      "2T2": "Lexus SUV",
      "2V4": " 2V8 Volkswagen Routan",
      "2WK": "Western Star Trucks truck",
      "2WL": " 2WM Western Star Trucks incomplete vehicle",
      "2XK": "Kenworth truck",
      "2XM": "Eagle Premier 1988 only (using AMC-style VIN structure)",
      "2XP": "Peterbilt truck",
      "3A4": " 3A8 Mexico Chrysler brand MPV 2006–2010 only",
      "3AK": " 3AL Freightliner Trucks",
      "3B3": "Dodge car 1981–2011",
      "3B4": "Dodge SUV 1986–1993",
      "3B6": "Dodge incomplete vehicle 1981–2002",
      "3B7": "Dodge truck 1981–2002",
      "3BJ": "Western Star 3700 truck made by DINA S.A.",
      "3BK": "Kenworth incomplete vehicle",
      "3BM": "Motor Coach Industries bus made by DINA S.A.",
      "3BP": "Peterbilt incomplete vehicle",
      "3C3": "Chrysler brand car 1981–2011",
      "3C4": "Chrysler Group (all brands) MPV (including Fiat) 2012-",
      "3C6": "Chrysler Group (all brands) truck 2012–",
      "3C7": "Chrysler Group (all brands) incomplete vehicle 2012–",
      "3C8": "Chrysler brand MPV 2001–2005",
      "3CE": "Volvo Buses de Mexico",
      "3CZ": "Honda SUV",
      "3D2": "Dodge incomplete vehicle 2007–2009",
      "3D3": "Dodge SUV 2009–2011",
      "3D6": "Dodge incomplete vehicle 2003–2011",
      "3D7": "Dodge truck 2002–2011",
      "3E4": "Fiat SUV",
      "3F ": "Ford",
      "3F6": "Sterling Bullet",
      "3FA": "Ford car",
      "3FC": "Ford stripped chassis made by Ford & IMMSA",
      "3FM": "Ford MPV/SUV",
      "3FN": " 3FR Ford F-650/F-750 made by Blue Diamond Truck Co.",
      "3FT": "Ford truck",
      "3G ": "General Motors[17]",
      "3G0": "Holden Equinox 2018–2020",
      "3G1": "Chevrolet car",
      "3G2": "Pontiac car",
      "3G4": "Buick car",
      "3G5": "Buick SUV",
      "3G7": "Pontiac SUV",
      "3GC": "Chevrolet truck",
      "3GK": "GMC SUV",
      "3GM": "Holden Suburban",
      "3GN": "Chevrolet SUV",
      "3GS": "Saturn SUV",
      "3GT": "GMC truck",
      "3GY": "Cadillac SUV",
      "3H1": "Honda motorcycle/UTV",
      "3H3":
          "Hyundai de Mexico, S.A. de C.V. for Hyundai Translead (truck trailers)",
      "3HA": "International Trucks incomplete vehicle",
      "3HC": "International Trucks truck",
      "3HG": "Honda car[17]",
      "3HS": "International Trucks & Caterpillar Trucks truck",
      "3HT": "International Trucks & Caterpillar Trucks incomplete vehicle",
      "3JB": "Can-Am ATV/UTV & Can-Am Ryker",
      "3KP": "Kia/Hyundai car[17]",
      "3LN": "Lincoln car",
      "3MD": "Mazda car",
      "3ME": "Mercury car",
      "3MV": "Mazda SUV",
      "3MW": "BMW",
      "3MY": "Toyota car made by Mazda de Mexico Vehicle Operation",
      "3MZ": "Mazda car",
      "3N1": "Nissan[17] car",
      "3N6": "Nissan truck & Chevrolet City Express",
      "3N8": "Nissan MPV",
      "3NE": "Polaris Inc. ATV",
      "3NS": "Polaris Inc. UTV",
      "3P3": "Plymouth car",
      "3PC": "Infiniti SUV made by COMPAS",
      "3TM": "Toyota truck made by TMMBC",
      "3TY": "Toyota truck made by TMMGT",
      "3VV": "Volkswagen SUV",
      "3VW": "Volkswagen car[17]",
      "3WK": "Kenworth truck",
      "3WP": "Peterbilt truck",
      "4A3": "United States Mitsubishi Motors car",
      "4A4": "Mitsubishi Motors SUV",
      "4B3": "Dodge car made by Diamond-Star Motors factory",
      "4B9": " 038 BYD Coach & Bus LLC",
      "4C3": "Chrysler car made by Diamond-Star Motors factory",
      "4C9": " 561 Czinger",
      "4CD": "Oshkosh Chassis Division incomplete vehicle (RV chassis)",
      "4DR": "IC Bus",
      "4E3": "Eagle car made by Diamond-Star Motors factory",
      "4F2": "Mazda[17] SUV made by Ford",
      "4F4": "Mazda truck made by Ford",
      "4G1":
          "Chevrolet Cavalier convertible made by Genasys L.C. – a GM/ASC joint venture",
      "4G2":
          "Pontiac Sunfire convertible made by Genasys L.C. – a GM/ASC joint venture",
      "4G3": "Toyota Cavalier made by GM",
      "4G5": "General Motors EV1",
      "4GD": "WhiteGMC Brigadier 1988–1989 made by GM",
      "4GL": "Buick incomplete vehicle",
      "4GT": "Isuzu incomplete vehicle built by GM",
      "4JG": "Mercedes-Benz SUV[17]",
      "4KB": "Chevrolet W-Series incomplete vehicle (gas engine only)",
      "4KD": "GMC W-Series incomplete vehicle (gas engine only)",
      "4KL": "Isuzu commercial truck built by GM",
      "4M2": "Mercury MPV/SUV",
      "4ML": "Oshkosh Trailer Division",
      "4MZ": "Buell Motorcycle Company",
      "4N2": "Nissan Quest made by Ford",
      "4NU": "Isuzu Ascender made by GM",
      "4P1": "Pierce Manufacturing",
      "4P3":
          "Mitsubishi Motors SUV made by Mitsubishi Motor Manufacturing of America 2013–2015 for export only",
      "4RK": "Nova Bus & Prevost made by Nova Bus (US) Inc.",
      "4S1": "Isuzu SUV made by Subaru Isuzu Automotive",
      "4S3": "Subaru car[17]",
      "4S4": "Subaru SUV/MPV[17]",
      "4S6": "Honda SUV made by Subaru Isuzu Automotive",
      "4S7": "Spartan Motors incomplete vehicle",
      "4S9": " 197 Smith Electric Vehicles US Corp.",
      "4T1": "Toyota[17] car made by Toyota Motor Manufacturing Kentucky",
      "4T3": "Toyota MPV/SUV made by Toyota Motor Manufacturing Kentucky",
      "4T4": "Toyota car made by Subaru of Indiana Automotive",
      "4T9": " 208 Xos, Inc.",
      "4TA": "Toyota truck made by NUMMI",
      "4UF": "Arctic Cat",
      "4US": "BMW car[17]",
      "4UZ":
          "Freightliner Custom Chassis Corporation & gas-powered Mitsubishi Fuso trucks assembled by Freightliner Custom Chassis & Thomas Built Buses FS-65 & Saf-T-Liner C2",
      "4V1": "WhiteGMC truck",
      "4V2": "WhiteGMC incomplete vehicle",
      "4V4": "Volvo Trucks North America truck",
      "4V5": "Volvo Trucks North America incomplete vehicle",
      "4VA": " 4VG Volvo Trucks North America truck",
      "4VE": " 4VH 4VM Volvo Trucks North America incomplete vehicle",
      "4VZ":
          "Spartan Motors/The Shyft Group incomplete vehicle – bare chassis only",
      "4XA": "Polaris Inc.",
      "4Z3": "American LaFrance truck",
      "43C": "Consulier",
      "46G": "Gillig incomplete vehicle",
      "478": "Honda ATV",
      "480": "Sterling Trucks truck",
      "49H": "Sterling Trucks incomplete vehicle",
      "5AS": "GEM",
      "5B4": "Workhorse Custom Chassis, LLC incomplete vehicle (RV chassis)",
      "5BZ": "Nissan (van with more than 3 rows of seats)",
      "5CD": "Indian Motorcycle Company of America Gilroy, CA",
      "5CX": "Shelby Series 1",
      "5DF": "Thomas Dennis Company LLC",
      "5EH": "Excelsior-Henderson Motorcycle",
      "5FN": "Honda[17] MPV/SUV made by Honda Manufacturing of Alabama",
      "5FP": "Honda truck made by Honda Manufacturing of Alabama",
      "5FR": "Acura[17] SUV made by Honda Manufacturing of Alabama",
      "5FY": "New Flyer",
      "5G8": "Holden Volt",
      "5GA": "Buick MPV/SUV",
      "5GD": "Daewoo G2X",
      "5GN": "Hummer H3T",
      "5GR": "Hummer H2",
      "5GT": "Hummer H3",
      "5GZ": "Saturn MPV/SUV",
      "5HD": "Harley-Davidson for export markets",
      "5J6": "Honda[17] SUV made by Honda of America Mfg. in Ohio",
      "5J8": "Acura SUV made by Honda of America Mfg. in Ohio",
      "5KB": "Honda[17] car made by Honda Manufacturing of Alabama",
      "5KJ": " 5KK Western Star Trucks truck",
      "5L1": "Lincoln SUV (2004–2009)",
      "5LD": "Ford & Lincoln incomplete vehicle – limousine (2010–2014)",
      "5LM": "Lincoln SUV",
      "5LT": "Lincoln truck",
      "5MZ": "Buell Motorcycle Company for export markets",
      "5N1": "Nissan & Infiniti SUV",
      "5N3": "Infiniti SUV",
      "5NM": "Hyundai SUV",
      "5NP": "Hyundai car",
      "5NT": "Hyundai truck",
      "5PV": "Hino incomplete vehicle",
      "5S3": "Saab 9-7X",
      "5SA": "Suzuki ATV",
      "5SX": "American LaFrance incomplete vehicle (Condor)",
      "5TB": "Toyota[17] truck made by TMMI",
      "5TD": "Toyota MPV/SUV made by TMMI",
      "5TE": "Toyota truck made by NUMMI",
      "5TF": "Toyota truck made by TMMTX",
      "5UM": "BMW M car[17]",
      "5UX": "BMW SUV",
      "5VC": "Autocar incomplete vehicle",
      "5VP": "Victory Motorcycles",
      "5WE": "IC Bus incomplete vehicle",
      "5XX": "Kia car",
      "5XY": "Kia/Hyundai SUV",
      "5Y2": "Pontiac Vibe made by NUMMI",
      "5Y4": "Yamaha Motor Company ATV, UTV",
      "5YA": "Indian Motorcycle Company Kings Mountain, NC",
      "5YF": "Toyota car made by TMMMS",
      "5YJ": "Tesla[17]",
      "5YM": "Suzuki truck made by Nissan",
      "50E": "Lucid Motors",
      "50G": "Karma Automotive",
      "516": "Autocar truck",
      "51R": "Brammo Motorcycles",
      "523": "VPG",
      "52C": "GEM subsidiary of Polaris Inc.",
      "538": "Zero Motorcycles",
      "53G": "Coda Automotive",
      "53T": "Think North America in Elkhart, IN",
      "546": "EBR",
      "54C": "Winnebago Industries trailer",
      "54D":
          "Isuzu & Chevrolet commercial trucks built by Spartan Motors/The Shyft Group",
      "55S": "Mercedes-Benz car[17]",
      "56K": "Indian Motorcycle International, LLC Polaris subsidiary",
      "57W": "Mobility Ventures",
      "57X": "Polaris Slingshot",
      "58A": "Lexus car made by TMMK",
      "Oce": "ania",
      "6F1": "Australia Ford[17]",
      "6F2": "Iveco Trucks Australia Ltd.",
      "6F4": "Nissan Motor Australia",
      "6F5": "Kenworth Australia",
      "6FM": "Mack Trucks Australia",
      "6FP": "Ford",
      "6G ": "General Motors",
      "6G1": "Holden & Chevrolet",
      "6G2": "Pontiac",
      "6G3": "Chevrolet",
      "6H ": "Holden",
      "6MM": "Mitsubishi[17]",
      "6MP": "Mercury Capri",
      "6T1": "Toyota",
      "6T9": "Trailer",
      "6U9": "Low Volume (Grey) Import",
      "6ZZ": "Low Volume (Grey) Import",
      "7A1": "New Zealand Mitsubishi",
      "7A3": "Honda",
      "7A4": "Toyota",
      "7A5": "Ford",
      "7A7": "Nissan New Zealand",
      "7A8": "NZ Transport Agency (pre-2009)",
      "7AT": "NZ Transport Agency (post–2009)",
      "7FA": "United States Honda SUV made by Honda Manufacturing of Indiana",
      "7FC": "Rivian truck",
      "7GZ": "GMC incomplete vehicles made by Navistar International",
      "7H4": "Hino truck",
      "7JR": "Volvo Cars car",
      "7JZ": "Proterra From mid-2019 on",
      "7KG": "Vanderhall Motor Works",
      "7MM": "Mazda SUV made by MTMUS (Mazda-Toyota Joint Venture)",
      "7MU": "Toyota SUV made by MTMUS (Mazda-Toyota Joint Venture)",
      "7NA": "Navistar Defense",
      "7NY": "Lordstown Motors",
      "7PD": "Rivian SUV",
      "7RZ": "Electric Last Mile Solutions",
      "7R4": "Icon Electric Vehicles",
      "7SA": "Tesla SUV 2022+",
      "7SU": "Blue Arc electric trucks made by The Shyft Group",
      "7SV": "Toyota SUV made by TMMTX",
      "7SX": "Global Electric Motorcars",
      "7Z0": "Zoox",
      "Sou": "th America",
      "8AC": "Argentina Mercedes Benz vans (for South America)",
      "8AD": "Peugeot",
      "8AE": "Peugeot van",
      "8AF": "Ford Motor Argentina[17]",
      "8AG": "General Motors de Argentina Chevrolet",
      "8AJ": "Toyota Argentina",
      "8AN": "Nissan",
      "8AP": "Fiat",
      "8AT": "Iveco",
      "8AW": "Volkswagen Argentina",
      "8A1": "Renault Argentina",
      "8A3": "Scania Argentina",
      "8BB": "Agrale Argentina S.A",
      "8BC": "Citroën",
      "8BN": "Mercedes-Benz incomplete vehicle (North America)",
      "8BR":
          "Mercedes-Benz (van with more than 3 rows of seats) (North America)",
      "8BT":
          "Mercedes-Benz MPV (van with 2 or 3 rows of seats) (North America)",
      "8BU":
          "Mercedes-Benz truck (cargo van with 1 row of seats) (North America)",
      "8CH": "Honda motorcycle",
      "8C3": "Honda car/SUV",
      "8F9": "Chile Reborn Electric Motors SPA",
      "8G1": "Automotores Franco Chilena S.A Renault",
      "8GD": "Automotores Franco Chilena S.A Peugeot",
      "8GG": "General Motors Chile Ltda.",
      "8L4":
          "Ecuador Great Wall Motors made by Ciudad del Auto Ciauto Cia. Ltda.",
      "8LB": "General Motors OBB",
      "8LF": "Maresa (Mazda)",
      "8LG": "Aymesa (Hyundai Motor & Kia)",
      "8XD": "Venezuela Ford Motor Venezuela",
      "8XJ": "Mack de Venezuela C.A.",
      "8XV": "Iveco Venezuela C.A.",
      "8Z1": "General Motors Venezolana C.A.",
      "829": "Bolivia Quantum Motors",
      "9AM": "Brazil Massari (?)",
      "9BD": "Fiat Automóveis",
      "9BF": "Ford Brasil",
      "9BG": "General Motors do Brasil Chevrolet",
      "9BH": "Hyundai Motor Brasil",
      "9BM": "Mercedes-Benz car & SUV & commercial truck",
      "9BN": "Mafersa",
      "9BR": "Toyota",
      "9BS": "Scania Brazil",
      "9BV": "Volvo Trucks",
      "9BW": "Volkswagen do Brasil[17]",
      "9BY": "Agrale S.A.",
      "9C2": "Honda Motorcycles[17]",
      "9C6": "Yamaha Motor[17]",
      "9CD": "Suzuki (motorcycles) assembled by J. Toledo Motos do Brasil",
      "9DW": "Kenworth & Peterbilt trucks made by Volkswagen do Brasil",
      "932": "Harley-Davidson",
      "935": "Citroën",
      "936": "Peugeot",
      "937": "Dodge",
      "93C": "General Motors do Brasil Chevrolet SUV (Mexico)",
      "93H": "Honda car/SUV",
      "93K": "Volvo Trucks",
      "93P": "Volare",
      "93S": "Navistar International",
      "93U": "Audi 1999–2006",
      "93V": "Navistar International",
      "93W": "Fiat Ducato made by Iveco 2000–2016",
      "93X": "Renault do Brasil",
      "93Z": "Iveco",
      "94D": "Nissan",
      "94G": "Indabra",
      "94M": "HVR-Busscar",
      "94N": "RWM Brazil",
      "94T": "VW Truck & Bus / MAN Truck & Bus",
      "95P": "CAOA / Hyundai & CAOA Chery",
      "95V": "BMW motorcycles assembled by Dafra Motos 2009–2016",
      "95Z": "Buell Motorcycle Company assembled by Harley-Davidson Brazil",
      "96P": "Kawasaki",
      "97N": "Triumph Motorcycles Ltd",
      "988": "Jeep and Fiat (made at the Goiana plant)",
      "98M": "BMW car/SUV",
      "98R": "Chery",
      "99A": "Audi 2016-",
      "99J": "Jaguar Land Rover",
      "99K": "Haojue & Kymco assembled by JTZ Indústria e Comércio de Motos",
      "99L": "BYD",
      "99Z": "BMW Motorrad Motorcycle assembled by BMW 2017-",
      "9FB": "Colombia Sofasa (Renault)",
      "9FC": "Compañía Colombiana Automotriz S.A. (Mazda)",
      "9GA": "GM Colmotores S.A. (Chevrolet)",
      "9UJ": "Uruguay Chery assembled by Chery Socma S.A.",
      "9UK": "Lifan",
      "9UW": "Kia made by Nordex S.A.",
      "9V7": "Citroen made by Nordex S.A.",
      "9V8": "Peugeot made by Nordex S.A."
    };

    // Assuming the first three characters of VIN represent the WMI code
    wmiCode = vin.substring(0, 3);

    if (wmiDetails.containsKey(wmiCode)) {
      setState(() {
        decodingResult += '''
          \n\nWMI Code: $wmiCode
          Name: ${wmiDetails[wmiCode]!}
        ''';
      });
    } else {
      setState(() {
        decodingResult += '\n\nWMI Code not found';
      });
    }
  }
}

final logger = Logger();

class VinDecoder {
  String country = '';
  String make = '';
  String continent = '';
  String modelYear = '';
  String engineSize = '';
  String model = '';
  String bodyStyle = '';
  String engineType = '';

  String wmiDetails = '';

  String name = '';
  String manufacturername = '';
  String enginenumberofcylinders = '';
  String drivetype = '';
  String transmissionstyle = '';
  String numberofseatrows = '';
  String modelyear = '';
  String doors = '';
  String plantcountry = '';
  String vehicletype = '';
  String bodyclass = '';

  Future<void> decodeVin(String vin) async {
    if (vin.length != 17) {
      throw ArgumentError("Invalid VIN code");
    }

    decodeVehicleDetails(vin);
    decodeCountry(vin[0]);
    decodeContinent(vin[3]);
    decodeEngineSize(vin[4]);
    decodeModelYear(vin[9]);
  }

  Future<void> decodeCountry(String v) async {
    var vmiDetails = {
      '1': 'North America',
      '4': 'North America',
      '5': 'North America',
      '2': 'South America',
      '3': 'Asia',
      '6': 'Oceania',
      '9': 'Africa',
      'J': 'Asia',
      'K': 'Asia',
      'L': 'Asia',
      'M': 'Asia',
      'N': 'Asia',
      'P': 'Asia',
      'R': 'Asia',
      'S': 'Europe',
      'T': 'Europe',
      'U': 'Europe',
      'V': 'Europe',
      'W': 'Europe',
      'X': 'Europe',
      'Y': 'Europe',
      'Z': 'Europe',
    };

    if (vmiDetails.containsKey(v)) {
      continent = vmiDetails[v]!;
    } else {
      throw ArgumentError("Invalid VMI code");
    }
  }

  void decodeContinent(String c) {
    switch (c) {
      case '1':
      case '4':
      case '5':
        country = 'North America';
        break;
      case '2':
      case 'TR':
        country = 'South America';
        break;
      case 'TJ':
      case 'TP':
        country = 'Czech';
        break;
      case 'TA':
      case 'TH':
        continent = 'Switzerland';
        break;
      case 'S1':
      case 's4':
        country = 'Latvia';
        break;
      case 'SU':
      case 'SZ':
        country = 'Poland';
        break;
      case 'SA':
      case 'SM':
        country = 'Great Britain';
        break;
      case 'SN':
      case 'ST':
        country = 'Germany';
      case 'U':
      case 'V':
      case 'W':
      case 'X':
      case 'Y':
      case 'Z':
        continent = 'Europe';
        break;
      default:
        ArgumentError("Invalid continent code");
    }
  }

  void decodeModelYear(String c) {
    var modelYearMap = {
      '0': "2000",
      '1': "2001",
      '2': "2002",
      '3': "2003",
      '4': "2004",
      '5': "2005",
      '6': "2006",
      '7': "2007",
      '8': "2008",
      '9': "2009",
      'A': "2010",
      'B': "2011",
      'C': "2012",
      'D': "2013",
      'E': "2014",
      'F': "2015",
      'G': "2016",
      'H': "2017",
      'J': "2018",
      'K': "2019",
      'L': "2020",
      'M': "2021",
      'N': "2022",
      'P': "2023",
      'R': "2024",
      'S': "2025",
      'T': "2026",
      'V': "2027",
      'W': "2028",
      'X': "2029",
      'Y': "2030",
    };

    if (modelYearMap.containsKey(c)) {
      modelYear = modelYearMap[c].toString();
    } else {
      ArgumentError("Invalid model year code");
    }
  }

  void decodeEngineSize(String c) {
    var engineSizeMap = {
      'A': "Gasoline, 3 or 4 cylinders",
      'B': "Gasoline, 3 or 4 cylinders",
      'C': "Gasoline, 4 or 6 cylinders",
      'D': "Gasoline, 4 or 6 cylinders",
      'E': "Gasoline, 4 or 6 cylinders",
      'F': "Gasoline, 4 or 6 cylinders",
      'G': "Gasoline, 6 or 8 cylinders",
      'H': "Gasoline, 6 or 8 cylinders",
      'J': "Gasoline, 6 or 8 cylinders",
      'K': "Gasoline, 6 or 8 cylinders",
      'L': "Gasoline, 6 or 8 cylinders",
      'M': "Gasoline, 8 cylinders",
      'N': "Gasoline, 8 cylinders",
      'P': "Gasoline, 8 cylinders",
      'R': "Gasoline, 8 cylinders",
      'S': "Diesel, 4 or 6 cylinders",
      'T': "Diesel, 4 or 6 cylinders",
      'U': "Diesel, 4 or 6 cylinders",
      'V': "Diesel, 4 or 6 cylinders",
      'W': "Diesel, 4 or 6 cylinders",
      'X': "Diesel, 6 or 8 cylinders",
      'Y': "Diesel, 6 or 8 cylinders",
      'Z': "Diesel, 6 or 8 cylinders",
      '1': "Electric",
      '2': "Hybrid",
      '3': "Hybrid",
      '4': "Hybrid",
      '5': "Hybrid",
      '6': "Hybrid",
      '7': "Hybrid",
      '8': "Hybrid",
      '9': "Hybrid",
    };

    if (engineSizeMap.containsKey(c)) {
      engineSize = engineSizeMap[c]!;
    } else {
      ArgumentError("Invalid engine size code");
    }
  }

  final Logger logger = Logger();

  // ... (other fields and methods remain the same)

  Future<String> decodeVehicleDetails(String vin) async {
    var url = "https://vpic.nhtsa.dot.gov/api/vehicles/decodevin";
    try {
      var response = await http.get(Uri.parse('$url/$vin?format=json'));

      logger.d('API Response: ${response.body}');

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json.containsKey('Results')) {
          var results = json['Results'];

          if (results is List && results.isNotEmpty) {
            for (var result in results) {
              var name = result['Variable'];
              var value = result['Value'];

              logger.d('Name: $name, Value: $value');

              switch (name) {
                case "Make":
                  make = value ?? '';
                  break;
                case "Model":
                  model = value ?? '';
                  break;
                case "Model Year":
                  modelyear = value ?? '';
                  break;
                case "Engine Model":
                  engineType = value ?? '';
                  break;
                case "Drive Type":
                  drivetype = value ?? '';
                  break;
                case "Manufacturer Name":
                  manufacturername = value ?? '';
                  break;
                case "Engine Number of Cylinders":
                  enginenumberofcylinders = value ?? '';
                  break;
                case "Transmission Style":
                  transmissionstyle = value ?? '';
                  break;
                case "Number of Seat Rows":
                  numberofseatrows = value ?? '';
                  break;
                case "Doors":
                  doors = value ?? '';
                  break;
                case "Plant Country":
                  plantcountry = value ?? '';
                  break;
                case "Vehicle Type":
                  vehicletype = value ?? '';
                  break;
                case "Body Class":
                  bodyclass = value ?? '';
                  break;
                case "Error Code":
                  if (value != "0") {
                    return 'Error decoding VIN: Error Code $value';
                  }
                  break;

                default:
                  break;
              }
            }

            return '''
Make: $make
Model: $model
Doors: $doors
Body Class: $bodyclass
Vehicle Type: $vehicletype
Model Year: $modelyear
Engine Type: $engineType
Drive Type: $drivetype
Engine Number of Cylinders : $enginenumberofcylinders
Plant Country: $plantcountry
Manufacturer Name: $manufacturername
Transmission Style: $transmissionstyle
Number of Seat Rows: $numberofseatrows

''';
          } else {
            logger.e(
                "VIN decoder service error: No results or empty results list");
            throw Exception(
                "VIN decoder service error: No results or empty results list");
          }
        } else {
          logger.e(
              "VIN decoder service error: 'Results' key not found in response");
          throw Exception(
              "VIN decoder service error: 'Results' key not found in response");
        }
      } else {
        logger.e(
            "Failed to fetch data from VIN decoder API. Status code: ${response.statusCode}");
        throw Exception(
            "Failed to fetch data from VIN decoder API. Status code: ${response.statusCode}");
      }
    } on FormatException catch (e) {
      logger.e("Error parsing data from VIN decoder API response: $e");
      throw Exception("Error parsing data from VIN decoder API response: $e");
    } on http.ClientException catch (e) {
      logger.e("HTTP error: $e");
      throw Exception("HTTP error: $e");
    } on Exception catch (e) {
      logger.e("Unknown error during VIN decoding: $e");
      throw Exception("Unknown error during VIN decoding: $e");
    }
  }
}
