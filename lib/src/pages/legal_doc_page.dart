import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pocketlist/src/localization/localization_constant.dart';

class LegalDocPage extends StatefulWidget {
  final String assetPath;
  final String titleKey;

  const LegalDocPage({
    Key? key,
    required this.assetPath,
    required this.titleKey,
  }) : super(key: key);

  @override
  State<LegalDocPage> createState() => _LegalDocPageState();
}

class _LegalDocPageState extends State<LegalDocPage> {
  String _markdownContent = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    try {
      final content = await rootBundle.loadString(widget.assetPath);
      setState(() {
        _markdownContent = content;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _markdownContent = 'Error loading document.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(getTranslated(context, widget.titleKey)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
         : Markdown(
              data: _markdownContent,
              styleSheet: MarkdownStyleSheet(
                h1: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                h2: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                h3: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
                p: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  height: 1.5,
                ),
                listBullet: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                strong: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                code: TextStyle(
                  fontSize: 13,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  fontFamily: 'monospace',
                ),
                codeblockDecoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                horizontalRuleDecoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
              padding: EdgeInsets.all(16),
            ),
    );
  }
}
