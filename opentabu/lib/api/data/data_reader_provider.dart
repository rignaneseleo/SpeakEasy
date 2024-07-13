/*
* OpenTabu is an Open Source game developed by Leonardo Rignanese <dev.rignanese@gmail.com>
* GNU Affero General Public License v3.0: https://choosealicense.com/licenses/agpl-3.0/
* GITHUB: https://github.com/rignaneseleo/OpenTabu
* */

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'csv_data_reader.dart';
import 'data_reader.dart';

part 'data_reader_provider.g.dart';

@Riverpod(keepAlive: true) //Enable cache
Future<DataReader> dataReader(DataReaderRef ref, String langCode) async {
  final dataReader = CSVDataReader();
  final res = await dataReader.loadFile(langCode);
  assert(res == true, "Error loading data file $langCode");
  return dataReader;
}
