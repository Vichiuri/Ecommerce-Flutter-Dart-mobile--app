import 'package:flutter/material.dart';

///error when loading paginated list
class ErrorPaginated extends StatelessWidget {
  const ErrorPaginated({Key? key, required VoidCallback onRefresh})
      : _onRefresh = onRefresh,
        super(key: key);
  final VoidCallback _onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 33,
        height: 33,
        child: IconButton(
          onPressed: _onRefresh,
          icon: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
