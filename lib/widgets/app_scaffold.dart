import 'package:flutter/material.dart';
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final Widget? bottomNavigationBar;
  final Color? gradientStart;
  final Color? gradientEnd;
  final PreferredSizeWidget? bottom;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
    this.showBack = true,
    this.bottomNavigationBar,
    this.gradientStart,
    this.gradientEnd,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: showBack
            ? leading ??
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => Navigator.pop(context),
                )
            : leading,
        actions: actions,
        bottom: bottom,
      ),
      body: Container(
        decoration: gradientStart != null && gradientEnd != null
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [gradientStart!, gradientEnd!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              )
            : null,
        child: SafeArea(
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
