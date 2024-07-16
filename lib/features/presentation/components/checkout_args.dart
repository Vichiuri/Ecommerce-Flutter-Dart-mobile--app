///checkout arguments
class CheckoutArgs {
  final String _notes;
  final bool _ok;

  CheckoutArgs({required String notes, required bool ok})
      : _notes = notes,
        _ok = ok;

  CheckoutArgs copyWith({
    String? notes,
    bool? ok,
  }) {
    return CheckoutArgs(
      notes: notes ?? this._notes,
      ok: ok ?? this._ok,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckoutArgs && other._notes == _notes && other._ok == _ok;
  }

  @override
  int get hashCode => _notes.hashCode ^ _ok.hashCode;

  @override
  String toString() => 'CheckoutArgs(_notes: $_notes, _ok: $_ok)';

  String get notes => this._notes;
  bool get ok => this._ok;
}

//checkout agumens