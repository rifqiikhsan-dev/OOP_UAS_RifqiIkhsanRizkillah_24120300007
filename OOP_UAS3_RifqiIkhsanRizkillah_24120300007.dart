import 'dart:collection';

abstract class Identifiable {
  String get id;
}

abstract class Person implements Identifiable {
  final String _personId;
  final String _name;
  final String _address;
  final DateTime _birthDate;
  final String _nationality;

  Person(this._personId, this._name, this._address, this._birthDate,
      this._nationality);

  @override
  String get id => _personId;

  String get name => _name;
  String get address => _address;
  DateTime get birthDate => _birthDate;
  String get nationality => _nationality;
  String getFullName() => _name;
}

class Player extends Person {
  final int _jerseyNumber;
  final double _marketValue;
  final String _position;

  final List<Team> _teams = [];

  Player(
    String personId,
    String name,
    String address,
    DateTime birthDate,
    String nationality,
    this._jerseyNumber,
    this._marketValue,
    this._position,
  ) : super(personId, name, address, birthDate, nationality);

  int get jerseyNumber => _jerseyNumber;
  double get marketValue => _marketValue;
  String get position => _position;

  void playMatch() =>
      print('$name (No. $_jerseyNumber) sedang bermain sebagai $_position.');

  void joinTeam(Team t) => _teams.add(t);
}

class Coach extends Person {
  final String _licenseLevel;
  final String _role;

  final List<Team> _teams = [];

  Coach(
    String personId,
    String name,
    String address,
    DateTime birthDate,
    String nationality,
    this._licenseLevel,
    this._role,
  ) : super(personId, name, address, birthDate, nationality);

  String get licenseLevel => _licenseLevel;
  String get role => _role;

  void selectSquad() => print('$name sedang memilih skuad.');
  void joinTeam(Team t) => _teams.add(t);
}

class Staff extends Person {
  final String _department;

  Staff(
    String personId,
    String name,
    String address,
    DateTime birthDate,
    String nationality,
    this._department,
  ) : super(personId, name, address, birthDate, nationality);

  String get department => _department;
  void performDuties() => print('$name bertugas pada departemen $_department.');
}

abstract class PersonCreator {
  Person createPerson(Map<String, dynamic> args);
}

class PlayerCreator extends PersonCreator {
  @override
  Player createPerson(Map<String, dynamic> a) => Player(
        a['id'],
        a['name'],
        a['addr'],
        a['dob'],
        a['nat'],
        a['jersey'],
        a['value'],
        a['pos'],
      );
}

class CoachCreator extends PersonCreator {
  @override
  Coach createPerson(Map<String, dynamic> a) => Coach(
        a['id'],
        a['name'],
        a['addr'],
        a['dob'],
        a['nat'],
        a['license'],
        a['role'],
      );
}

class StaffCreator extends PersonCreator {
  @override
  Staff createPerson(Map<String, dynamic> a) => Staff(
        a['id'],
        a['name'],
        a['addr'],
        a['dob'],
        a['nat'],
        a['dept'],
      );
}

class Club implements Identifiable {
  final String _clubId;
  final String _name;
  final double _budget;
  final String _league;

  final List<Team> _teams = [];
  final Set<Sponsor> _sponsors = HashSet<Sponsor>();
  final List<TrainingSession> _sessions = [];

  Club(this._clubId, this._name, this._budget, this._league);

  @override
  String get id => _clubId;

  String get name => _name;
  double get budget => _budget;
  String get league => _league;

  void addTeam(Team t) => _teams.add(t);
  void addSponsor(Sponsor s) => _sponsors.add(s);
  void addTrainingSession(TrainingSession s) => _sessions.add(s);

  List<Team> get teams => List.unmodifiable(_teams);
}

class Team implements Identifiable {
  final String _teamId;
  final String _name;
  final String _division;
  final double _budget;
  final Club _club;

  final List<Player> _players = [];
  final List<Coach> _coaches = [];
  final List<TrainingSession> _sessions = [];

  Team(this._teamId, this._name, this._division, this._budget, this._club);

  @override
  String get id => _teamId;

  String get name => _name;
  String get division => _division;
  double get budget => _budget;
  Club get club => _club;

  void recruit(PersonCreator factory, Map<String, dynamic> args) {
    final person = factory.createPerson(args);
    if (person is Player) {
      _players.add(person);
      person.joinTeam(this);
    } else if (person is Coach) {
      _coaches.add(person);
      person.joinTeam(this);
    } else if (person is Staff) {}
  }

  void addTrainingSession(TrainingSession s) => _sessions.add(s);

  List<Player> get players => List.unmodifiable(_players);
  List<Coach> get coaches => List.unmodifiable(_coaches);
}

class Sponsor implements Identifiable {
  final String _sponsorId;
  final String _email;

  Sponsor(this._sponsorId, this._email);

  @override
  String get id => _sponsorId;
}

class TrainingSession implements Identifiable {
  final String _sessionId;
  final DateTime _sessionDate;
  final String _location;
  final String _focusArea;

  final Set<Player> _attendance = HashSet<Player>();

  TrainingSession(
      this._sessionId, this._sessionDate, this._location, this._focusArea);

  @override
  String get id => _sessionId;

  void recordAttendance(Player p, bool present) {
    present ? _attendance.add(p) : _attendance.remove(p);
  }

  Set<Player> get attendees => Set.unmodifiable(_attendance);
}

class Match implements Identifiable {
  final String _matchId;
  final DateTime _matchDate;
  final int _homeScore;
  final int _awayScore;
  final Season _season;
  final Stadium _stadium;
  final Team _home;
  final Team _away;

  Match(this._matchId, this._matchDate, this._homeScore, this._awayScore,
      this._season, this._stadium, this._home, this._away);

  @override
  String get id => _matchId;
}

class Season implements Identifiable {
  final String _seasonId;
  final int _year;
  final DateTime _startDate;
  final DateTime _endDate;
  final List<Match> _matches = [];

  Season(this._seasonId, this._year, this._startDate, this._endDate);
  @override
  String get id => _seasonId;
}

class Stadium implements Identifiable {
  final String _stadiumId;
  final String _name;
  final String _location;

  Stadium(this._stadiumId, this._name, this._location);
  @override
  String get id => _stadiumId;
}

void main() {
  final club = Club('C001', 'FC Cakrawala', 1000000000, 'Liga Mahasiswa');
  final team = Team('T001', 'FC Cakrawala Muda', 'U‑23', 500000000, club);
  club.addTeam(team);

  final coachFactory = CoachCreator();
  final playerFactory = PlayerCreator();

  team.recruit(coachFactory, {
    'id': 'P001',
    'name': 'Budi Santoso',
    'addr': 'Jl. Kebon Jeruk 10',
    'dob': DateTime(1975, 5, 15),
    'nat': 'Indonesia',
    'license': 'Pro License',
    'role': 'Head Coach'
  });

  team.recruit(coachFactory, {
    'id': 'P002',
    'name': 'Citra Dewi',
    'addr': 'Jl. Anggrek 20',
    'dob': DateTime(1985, 9, 25),
    'nat': 'Indonesia',
    'license': 'A License',
    'role': 'Assistant Coach'
  });

  for (int i = 1; i <= 15; i++) {
    team.recruit(playerFactory, {
      'id': 'P${100 + i}',
      'name': 'Mhs $i',
      'addr': 'Asrama No.$i',
      'dob': DateTime(2002, 1, i),
      'nat': 'Indonesia',
      'jersey': i + 1,
      'value': 1000000.0 + i * 10000.0,
      'pos': switch (i % 3) {
        0 => 'Forward',
        1 => 'Midfielder',
        _ => 'Defender'
      }
    });
  }

  final ts = TrainingSession(
      'TS001', DateTime(2025, 7, 11, 9), 'Lapangan U‑Cakrawala', 'Passing');
  team.addTrainingSession(ts);
  ts.recordAttendance(team.players[0], true);
  ts.recordAttendance(team.players[1], true);

  print('Klub : ${club.name}');
  print('Tim  : ${team.name}');
  print(
      'Pelatih Kepala : ${team.coaches.firstWhere((c) => c.role == "Head Coach").name}');
  print('Jumlah pemain  : ${team.players.length}');
  print('Pemain hadir   : ${ts.attendees.map((p) => p.name).join(", ")}');
}
