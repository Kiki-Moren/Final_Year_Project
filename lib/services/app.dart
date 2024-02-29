import 'package:final_year_project_kiki/models/currency.dart';
import 'package:final_year_project_kiki/state/app_state.dart';
import 'package:final_year_project_kiki/utilities/exceptions.dart';
import 'package:final_year_project_kiki/utilities/network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final appApiProvider = Provider<AppService>((ref) => AppService());

class AppService {
  Network network = NetworkImplementation();

  Future<void> getCurrencies({
    required WidgetRef ref,
    required void Function(String message) onError,
  }) async {
    List<Country> currencyList = [];

    try {
      List<Map<String, String>> response = [
        {
          "currency": "USD",
          "name": "United States Dollar",
          "symbol": "\$",
        },
        {
          "currency": "EUR",
          "name": "Euro",
          "symbol": "€",
        },
        {
          "currency": "GBP",
          "name": "British Pound",
          "symbol": "£",
        },
        {
          "currency": "NGN",
          "name": "Nigerian Naira",
          "symbol": "₦",
        },
        {
          "currency": "KES",
          "name": "Kenyan Shilling",
          "symbol": "KSh",
        },
        {
          "currency": "GHS",
          "name": "Ghanaian Cedi",
          "symbol": "GH₵",
        },
        {
          "currency": "ZAR",
          "name": "South African Rand",
          "symbol": "R",
        },
        {
          "currency": "XOF",
          "name": "West African CFA Franc",
          "symbol": "CFA",
        },
        {
          "currency": "XAF",
          "name": "Central African CFA Franc",
          "symbol": "CFA",
        },
        {
          "currency": "RWF",
          "name": "Rwandan Franc",
          "symbol": "FRw",
        },
        {
          "currency": "TZS",
          "name": "Tanzanian Shilling",
          "symbol": "TSh",
        },
        {
          "currency": "UGX",
          "name": "Ugandan Shilling",
          "symbol": "USh",
        },
        {
          "currency": "SLL",
          "name": "Sierra Leonean Leone",
          "symbol": "Le",
        },
        {
          "currency": "LRD",
          "name": "Liberian Dollar",
          "symbol": "L",
        },
        {
          "currency": "GMD",
          "name": "Gambian Dalasi",
          "symbol": "D",
        },
        {
          "currency": "GIP",
          "name": "Gibraltar Pound",
          "symbol": "£",
        },
        {
          "currency": "FKP",
          "name": "Falkland Islands Pound",
          "symbol": "£",
        },
        {
          "currency": "CUP",
          "name": "Cuban Peso",
          "symbol": "₱",
        },
        {
          "currency": "CUC",
          "name": "Cuban Convertible Peso",
          "symbol": "₱",
        },
        {
          "currency": "COP",
          "name": "Colombian Peso",
          "symbol": "COL\$",
        },
        {
          "currency": "CLP",
          "name": "Chilean Peso",
          "symbol": "CLP\$",
        },
        {
          "currency": "BRL",
          "name": "Brazilian Real",
          "symbol": "R\$",
        },
        {
          "currency": "BOB",
          "name": "Bolivian Boliviano",
          "symbol": "Bs",
        },
        {
          "currency": "ARS",
          "name": "Argentine Peso",
          "symbol": "AR\$",
        },
        {
          "currency": "AUD",
          "name": "Australian Dollar",
          "symbol": "A\$",
        },
        {
          "currency": "CAD",
          "name": "Canadian Dollar",
          "symbol": "C\$",
        },
        {
          "currency": "CNY",
          "name": "Chinese Yuan",
          "symbol": "¥",
        },
        {
          "currency": "JPY",
          "name": "Japanese Yen",
          "symbol": "¥",
        },
        {
          "currency": "INR",
          "name": "Indian Rupee",
          "symbol": "₹",
        },
        {
          "currency": "PKR",
          "name": "Pakistani Rupee",
          "symbol": "₨",
        },
        {
          "currency": "BDT",
          "name": "Bangladeshi Taka",
          "symbol": "৳",
        },
        {
          "currency": "LKR",
          "name": "Sri Lankan Rupee",
          "symbol": "₨",
        },
      ];

      for (int i = 0; i < response.length; i++) {
        currencyList.add(Country.fromJson(response[i]));
      }

      ref.read(currencies.notifier).state = currencyList;
    } on CustomException catch (e) {
      onError(e.toString());
    } catch (e) {
      onError('Network error, check your network connection');
    }
  }

  Future<double> getConversionValue({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
    required WidgetRef ref,
    required void Function(String message) onError,
  }) async {
    try {
      var response = await network.get(
        'https://api.api-ninjas.com/v1/convertcurrency?want=$toCurrency&have=$fromCurrency&amount=$amount',
        incomingHeaders: {
          "X-Api-Key": "gqnmSOwaMx1vKRy5cNoS3w==DH77dB3J7e3cZu7b"
        },
      );

      Logger().d(response);

      return response['new_amount'];
    } on CustomException catch (e) {
      onError(e.toString());
      return 0.0;
    } catch (e) {
      onError('Network error, check your network connection');
      return 0.0;
    }
  }
}
