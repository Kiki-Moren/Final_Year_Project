import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

FutureOr<void> main() async {
  await Supabase.initialize(
    url: 'https://cepkjgizjxepkoxdlqfw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlcGtqZ2l6anhlcGtveGRscWZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDY2ODYwNjQsImV4cCI6MjAyMjI2MjA2NH0.V1sF3qga1iaqotbK_ayjoKOB9UkvHO1GPKoPZZzApGU',
  );
  // final supabase = Supabase.instance.client;
  runApp(const App());
}
