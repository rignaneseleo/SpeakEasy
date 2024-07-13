import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

part 'shared_pref_provider.g.dart';

//TODO: This needs instantiation in runApp: https://riverpod.dev/docs/concepts/scopes#initialization-of-synchronous-provider-for-async-apis
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) =>
    throw UnimplementedError("This needs instantiation in runApp, see: https://riverpod.dev/docs/concepts/scopes#initialization-of-synchronous-provider-for-async-apis");
