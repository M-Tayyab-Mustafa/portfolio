//* Dart Common Exports
export 'dart:async';
export 'dart:convert';
export 'dart:isolate';
export 'dart:developer' hide Flow;
export 'dart:math' hide log;

//* Flutter Common Exports
export 'package:flutter/services.dart';
export 'package:flutter/material.dart';
export 'package:flutter/cupertino.dart' hide Flow hide ErrorWidget hide RefreshCallback;
export 'package:flutter/foundation.dart';

//* Clean Folder Structure Exports
export '../data/export.dart';
export '../domain/export.dart';
export '../presentation/export.dart';

//* Utils Extensions Exports
export 'extensions/text.dart';
export 'extensions/color.dart';
export 'inherited_widgets/device_type.dart';

//* Utils Router Exports
export 'router/transition.dart';
export 'router/generator.dart';
export 'router/names.dart';

//* Utils Services Exports
//? Local
// export 'services/local/';
//? Remote
// export 'services/remote/';

//* Utils Exports
export 'enums.dart';
export 'env.dart';
export 'helpers.dart';
export 'urls.dart';

//* Third Party Exports
export 'package:window_manager/window_manager.dart';
export 'package:go_router/go_router.dart';
export 'package:bloc/bloc.dart' hide Transition;
export 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
