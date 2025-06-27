import 'summary_card.dart';
import 'summary_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SummaryCarousel extends StatefulWidget {
  /// Total income amount
  final double totalIncome;

  /// Total expense amount
  final double totalExpense;

  const SummaryCarousel({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  State<SummaryCarousel> createState() => _SummaryCarouselState();
}

class _SummaryCarouselState extends State<SummaryCarousel>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Animated carousel of financial widgets
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: SizedBox(
            height: 240, // Fixed height for carousel
            child: PageView.builder(
              controller: _pageController,
              physics:
                  const BouncingScrollPhysics(), // Add bouncing effect for better feedback
              itemCount: 2, // Summary card and chart
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                // Add haptic feedback when switching pages
                HapticFeedback.lightImpact();
              },
              itemBuilder: (context, index) {
                // Select which widget to show based on index
                if (index == 0) {
                  // Summary card page
                  return Hero(
                    tag: 'summary1-card',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SummaryCard(
                        totalIncome: widget.totalIncome,
                        totalExpense: widget.totalExpense,
                        balance: widget.totalIncome - widget.totalExpense,
                      ),
                    ),
                  );
                } else {
                  // Chart widget page
                  return Hero(
                    tag: 'chart-widget',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SummaryChart(
                          totalIncome: widget.totalIncome,
                          totalExpense: widget.totalExpense,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Animated page indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (index) => TweenAnimationBuilder(
              tween: Tween<double>(
                begin: 0.0,
                end: _currentPage == index ? 1.0 : 0.0,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, double value, _) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: value * 24 + 8, // Animated width
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Swipe indicator text
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'Arraste para Visualizar o ${_currentPage == 0 ? "Gráfico" : "Resumo"}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
