import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'custom_shimmer.dart';

class PreviewShimmer extends StatelessWidget {
  const PreviewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 320,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 17, 53, 97), Color(0xFF030920)],
            ),
          ),
        ),
        Positioned.fill(
          top: 320,
          child: Container(
            color: Color(0xFF030920),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: ShimmerContainer(
                width: 100, height: 20, borderRadius: BorderRadius.circular(8)),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeaderShimmer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: ShimmerContainer(
                              width: 80,
                              height: 32,
                              borderRadius: BorderRadius.circular(8))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: ShimmerContainer(
                              width: 80,
                              height: 32,
                              borderRadius: BorderRadius.circular(8))),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // Tabs shimmer
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        // TabBar shimmer (already above)
                        Expanded(
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _OverviewTabShimmer(),
                              _BusinessTabShimmer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: null,
        ),
      ],
    );
  }
}

class _ProfileHeaderShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          ShimmerContainer(
            width: 90,
            height: 90,
            borderRadius: BorderRadius.circular(45),
          ),
          const SizedBox(height: 12),
          ShimmerContainer(
              width: 120, height: 20, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerContainer(
                  width: 18,
                  height: 18,
                  borderRadius: BorderRadius.circular(8)),
              const SizedBox(width: 4),
              ShimmerContainer(
                  width: 60,
                  height: 16,
                  borderRadius: BorderRadius.circular(8)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerContainer(
                  width: 80,
                  height: 24,
                  borderRadius: BorderRadius.circular(20)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerContainer(
                  width: 18,
                  height: 18,
                  borderRadius: BorderRadius.circular(8)),
              const SizedBox(width: 6),
              ShimmerContainer(
                  width: 80,
                  height: 16,
                  borderRadius: BorderRadius.circular(8)),
              const SizedBox(width: 18),
              ShimmerContainer(
                  width: 18,
                  height: 18,
                  borderRadius: BorderRadius.circular(8)),
              const SizedBox(width: 6),
              ShimmerContainer(
                  width: 120,
                  height: 16,
                  borderRadius: BorderRadius.circular(8)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerContainer(
                  width: 150,
                  height: 40,
                  borderRadius: BorderRadius.circular(10)),
              const SizedBox(width: 16),
              ShimmerContainer(
                  width: 150,
                  height: 40,
                  borderRadius: BorderRadius.circular(10)),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _OverviewTabShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ShimmerContainer(
              width: 80, height: 18, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 8),
          ShimmerContainer(
              width: double.infinity,
              height: 40,
              borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 24),
          ShimmerContainer(
              width: 80, height: 18, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 8),
          ShimmerContainer(
              width: 120, height: 16, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 8),
          ShimmerContainer(
              width: 180, height: 16, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 8),
          ShimmerContainer(
              width: 120, height: 16, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 24),
          ShimmerContainer(
              width: 180, height: 18, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 12),
          // Social cards shimmer
          ...List.generate(
              2,
              (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        ShimmerContainer(
                            width: 28,
                            height: 28,
                            borderRadius: BorderRadius.circular(8)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerContainer(
                                  width: 80,
                                  height: 14,
                                  borderRadius: BorderRadius.circular(8)),
                              const SizedBox(height: 6),
                              ShimmerContainer(
                                  width: 120,
                                  height: 12,
                                  borderRadius: BorderRadius.circular(8)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ShimmerContainer(
                            width: 24,
                            height: 24,
                            borderRadius: BorderRadius.circular(8)),
                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}

class _BusinessTabShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(
                  width: 120,
                  height: 20,
                  borderRadius: BorderRadius.circular(8)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 2,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _CompanyCardShimmer(),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompanyCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(
            width: double.infinity,
            height: 120,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerContainer(
                    width: 120,
                    height: 18,
                    borderRadius: BorderRadius.circular(8)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerContainer(
                        width: 30,
                        height: 12,
                        borderRadius: BorderRadius.circular(8)),
                    const SizedBox(width: 4),
                    ...List.generate(
                        3,
                        (i) => Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: ShimmerContainer(
                                  width: 12,
                                  height: 12,
                                  borderRadius: BorderRadius.circular(6)),
                            )),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ShimmerContainer(
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.circular(8)),
                    const SizedBox(width: 8),
                    ShimmerContainer(
                        width: 80,
                        height: 14,
                        borderRadius: BorderRadius.circular(8)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerContainer(
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.circular(8)),
                    const SizedBox(width: 8),
                    ShimmerContainer(
                        width: 80,
                        height: 14,
                        borderRadius: BorderRadius.circular(8)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerContainer(
                        width: 16,
                        height: 16,
                        borderRadius: BorderRadius.circular(8)),
                    const SizedBox(width: 8),
                    ShimmerContainer(
                        width: 120,
                        height: 14,
                        borderRadius: BorderRadius.circular(8)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
