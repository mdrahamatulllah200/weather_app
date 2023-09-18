import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'placeholders.dart';

class LoadingListPage extends StatefulWidget {
  const LoadingListPage({super.key});

  @override
  State<LoadingListPage> createState() => _LoadingListPageState();
}

class _LoadingListPageState extends State<LoadingListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Loading List'),
        // ),
        body: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            // enabled: true,
            child: const SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  BannerPlaceholder(),
                  TitlePlaceholder(width: double.infinity),
                  SizedBox(height: 30.0),
                  ContentPlaceholder(
                    lineType: ContentLineType.threeLines,
                  ),
                  SizedBox(height: 20.0),
                  TitlePlaceholder(width: 200.0),
                  SizedBox(height: 20.0),
                  ContentPlaceholder(
                    lineType: ContentLineType.twoLines,
                  ),
                  SizedBox(height: 16.0),
                  TitlePlaceholder(width: 200.0),
                  SizedBox(height: 16.0),
                  ContentPlaceholder(
                    lineType: ContentLineType.twoLines,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
