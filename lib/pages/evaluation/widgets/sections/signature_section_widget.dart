import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/constants/routes.dart';
import 'package:manager_mobile/core/enums/photo_state.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/core/util/internet_connection.dart';
import 'package:manager_mobile/core/util/message.dart';

class SignatureSectionWidget extends StatefulWidget {
  const SignatureSectionWidget({
    super.key,
    required this.evaluationController,
  });
  final EvaluationController evaluationController;
  @override
  State<SignatureSectionWidget> createState() => _SignatureSectionWidgetState();
}

class _SignatureSectionWidgetState extends State<SignatureSectionWidget> {
  String? downloadingSignature;

  void _takeSignature() {
    final controller = widget.evaluationController;
    if (controller.source == SourceTypes.fromSavedWithSign) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushNamed(Routes.captureSignature);
  }

  Future<void> _downloadSignature(String cloudPath) async {
    final hasInternet = await InternetConnectionStream.hasInternetNow();
    final controller = widget.evaluationController;
    if (!hasInternet) {
      if (!mounted) return;
      Message.showInfoSnackbar(context: context, message: 'Sem conexão com a internet');
      return;
    }

    setState(() {
      downloadingSignature = cloudPath;
    });

    try {
      await controller.downloadSignature();
    } finally {
      if (mounted) {
        setState(() {
          downloadingSignature = null;
        });
      }
    }
  }

  Widget _downloadingWidget() {
    return const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _downloadWidget() {
    return Icon(
      Icons.cloud_download,
      color: Theme.of(context).colorScheme.primary,
      size: 38,
    );
  }

  Widget _viewWidget(String path) {
    return Image.file(
      File(path),
      fit: BoxFit.scaleDown,
    );
  }

  Widget _emptyWidget() {
    return Center(
      child: Text(
        'Toque para assinar',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }

  Widget _buildSignatureContent({required PhotoState state, String? tempPath, String? localPath}) {
    switch (state) {
      case PhotoState.downloading:
        return _downloadingWidget();

      case PhotoState.temp:
        return _viewWidget(tempPath!);

      case PhotoState.local:
        return _viewWidget(localPath!);

      case PhotoState.cloud:
        return _downloadWidget();

      case PhotoState.empty:
        return _emptyWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    EvaluationController controller = widget.evaluationController;
    final tempPath = controller.evaluation!.signatureTempPath;
    final cloudPath = controller.evaluation!.signatureCloudPath;
    final localPath = controller.evaluation!.signatureLocalPath;

    final state = PhotoState.getPhotoState(tempPath, localPath, cloudPath, downloadingSignature == null ? {} : {downloadingSignature!});
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              switch (state) {
                case PhotoState.downloading:
                  return;
                case PhotoState.cloud:
                  _downloadSignature(cloudPath!);
                case PhotoState.temp || PhotoState.local:
                  _takeSignature();
                case PhotoState.empty:
                  _takeSignature();
              }
            },
            child: ListenableBuilder(
                listenable: controller,
                builder: (context, child) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    child: _buildSignatureContent(state: state, tempPath: tempPath, localPath: localPath),
                  );
                }),
          ),
        ],
      )),
    );
  }
}
