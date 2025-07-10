import 'dart:collection';

abstract class Identifiable {
  String get id;
}

class Club implements Identifiable {
  final String _clubId;
  final String _name;
  final double _budget;
  final String _description;
  final String _league;

  final List<TrainingSession> _trainingSessions = [];
  final List<Team> _teams = [];
  final Set<Sponsor> _sponsors = HashSet<Sponsor>();

  Club(this._clubId, this._name, this._budget, this._description, this._league);

  @override
  String get id => _clubId;

  String get name => _name;
  double get budget => _budget;
  String get description => _description;
  String get league => _league;

  void addTrainingSession(TrainingSession session) =>
      _trainingSessions.add(session);
  void addTeam(Team team) => _teams.add(team);
  void addSponsor(Sponsor sponsor) => _sponsors.add(sponsor);

  List<Team> get teams => List.unmodifiable(_teams);
  List<TrainingSession> get trainingSessions =>
      List.unmodifiable(_trainingSessions);
  Set<Sponsor> get sponsors => Set.unmodifiable(_sponsors);
}

abstract class Person implements Identifiable {
  final String _personId;
  final String _name;
  final String _address;
  final DateTime _birthDate;
  final String _nationality;

  final List<Contract> _contracts = [];

  Person(this._personId, this._name, this._address, this._birthDate,
      this._nationality);

  @override
  String get id => _personId;

  String get name => _name;
  String get address => _address;
  DateTime get birthDate => _birthDate;
  String get nationality => _nationality;

  void addContract(Contract c) => _contracts.add(c);
  List<Contract> get contracts => List.unmodifiable(_contracts);

  String get fullName => _name;
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

  String performDuties() =>
      '$name sedang menjalankan tugas di departemen $_department.';
}

class Player extends Person {
  final int _jerseyNumber;
  final double _marketValue;
  final String _position;

  final List<Team> _teams = [];
  final Set<TrainingSession> _sessionsAttended = HashSet<TrainingSession>();

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

  String playMatch() => '$name (No. $_jerseyNumber) sedang bermain.';

  void addTeam(Team t) => _teams.add(t);
  List<Team> get teams => List.unmodifiable(_teams);

  void addSession(TrainingSession s) => _sessionsAttended.add(s);
  Set<TrainingSession> get sessionsAttended =>
      Set.unmodifiable(_sessionsAttended);
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

  String selectSquad() => '$name sedang memilih skuad.';
  void addTeam(Team t) => _teams.add(t);
  List<Team> get teams => List.unmodifiable(_teams);
}

class Team implements Identifiable {
  final String _teamId;
  final String _name;
  final String _league;
  final String _division;
  final double _budget;
  final String _sport;
  final Club _club;

  final List<Player> _players = [];
  final List<Coach> _coaches = [];
  final List<TrainingSession> _trainingSessions = [];

  Team(
    this._teamId,
    this._name,
    this._league,
    this._division,
    this._budget,
    this._sport,
    this._club,
  );

  @override
  String get id => _teamId;

  String get name => _name;
  String get league => _league;
  String get division => _division;
  double get budget => _budget;
  String get sport => _sport;
  Club get club => _club;

  void addPlayer(Player p) {
    _players.add(p);
    p.addTeam(this);
  }

  void addCoach(Coach c) {
    _coaches.add(c);
    c.addTeam(this);
  }

  void addTrainingSession(TrainingSession s) => _trainingSessions.add(s);

  List<Player> get players => List.unmodifiable(_players);
  List<Coach> get coaches => List.unmodifiable(_coaches);
  List<TrainingSession> get trainingSessions =>
      List.unmodifiable(_trainingSessions);
}

class Contract implements Identifiable {
  final String _contractId;
  final DateTime _startDate;
  final DateTime _endDate;
  final double _salary;
  final String _role;
  final Person _person;

  Contract(
    this._contractId,
    this._startDate,
    this._endDate,
    this._salary,
    this._role,
    this._person,
  );

  @override
  String get id => _contractId;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  double get salary => _salary;
  String get role => _role;
  Person get person => _person;
}

class Sponsor implements Identifiable {
  final String _sponsorId;
  final String _name;
  final String _phone;
  final String _email;
  DateTime _contractEndDate;
  final DateTime _contractDate;

  final Set<Club> _clubs = HashSet<Club>();

  Sponsor(
    this._sponsorId,
    this._name,
    this._phone,
    this._email,
    this._contractDate,
    this._contractEndDate,
  );

  @override
  String get id => _sponsorId;

  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  DateTime get contractDate => _contractDate;
  DateTime get contractEndDate => _contractEndDate;

  void renew(DateTime newEnd) {
    _contractEndDate = newEnd;
    print('Kontrak $_name diperpanjang hingga $newEnd');
  }

  void addClub(Club c) {
    _clubs.add(c);
    c.addSponsor(this);
  }

  Set<Club> get clubs => Set.unmodifiable(_clubs);
}

class TrainingSession implements Identifiable {
  final String _sessionId;
  final DateTime _time;
  final String _location;
  final String _focus;
  final Team _team;

  final Set<Player> _presentPlayers = HashSet<Player>();

  TrainingSession(
    this._sessionId,
    this._time,
    this._location,
    this._focus,
    this._team,
  );

  @override
  String get id => _sessionId;

  DateTime get time => _time;
  String get location => _location;
  String get focus => _focus;
  Team get team => _team;

  void record(Player p, bool present) {
    if (present) {
      _presentPlayers.add(p);
      p.addSession(this);
    } else {
      _presentPlayers.remove(p);
    }
  }

  Set<Player> get presentPlayers => Set.unmodifiable(_presentPlayers);
}

class Match implements Identifiable {
  final String _matchId;
  final DateTime _matchDate;
  final String _time;
  final String _homeScore;
  final String _awayScore;
  final String _result;
  final Season _season;
  final Stadium _stadium;
  final Team _home;
  final Team _away;

  Match(
    this._matchId,
    this._matchDate,
    this._time,
    this._homeScore,
    this._awayScore,
    this._result,
    this._season,
    this._stadium,
    this._home,
    this._away,
  );

  @override
  String get id => _matchId;

  DateTime get matchDate => _matchDate;
  String get time => _time;
  String get homeScore => _homeScore;
  String get awayScore => _awayScore;
  String get result => _result;
  Season get season => _season;
  Stadium get stadium => _stadium;
  Team get homeTeam => _home;
  Team get awayTeam => _away;
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

  int get year => _year;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  void addMatch(Match m) => _matches.add(m);
  List<Match> get matches => List.unmodifiable(_matches);
}

class Stadium implements Identifiable {
  final String _stadiumId;
  final String _name;
  final String _location;
  final String _address;

  Stadium(this._stadiumId, this._name, this._location, this._address);

  @override
  String get id => _stadiumId;

  String get name => _name;
  String get location => _location;
  String get address => _address;

  String host(Match m) =>
      'Stadion $_name menyelenggarakan pertandingan ${m.id}.';
}

void main() {
  final club = Club(
      'C001', 'FC Cakrawala', 1e9, 'Universitas Cakrawala', 'Liga Mahasiswa');
  final team = Team('T001', 'FC Cakrawala Muda', 'Liga Mahasiswa', 'U-23', 5e8,
      'Football', club);
  club.addTeam(team);

  final headCoach = Coach('P001', 'Budi Santoso', 'Jl. Kebon Jeruk 10',
      DateTime(1975, 5, 15), 'Indonesia', 'Pro License', 'Head Coach');
  final asCoach = Coach('P002', 'Citra Dewi', 'Jl.Anggrek20',
      DateTime(1985, 9, 25), 'Indonesia', 'A License', 'Assistant Coach');
  team.addCoach(headCoach);
  team.addCoach(asCoach);

  for (int i = 1; i <= 15; i++) {
    final p = Player(
      'P${100 + i}',
      'Mhs $i',
      'Asrama No.$i',
      DateTime(2002, 1, i),
      'Indonesia',
      i + 1,
      1000000 + i * 10000,
      switch (i % 3) { 0 => 'Forward', 1 => 'Midfielder', _ => 'Defender' },
    );
    team.addPlayer(p);
  }

  final ts = TrainingSession('TS001', DateTime(2025, 7, 11, 9),
      'Lapangan U-Cakrawala', 'Passing', team);
  team.addTrainingSession(ts);
  club.addTrainingSession(ts);
  ts.record(team.players[0], true);
  ts.record(team.players[1], true);
  ts.record(team.players[2], false);

  print('Klub: ${club.name}');
  print('Tim : ${team.name}');
  print('Pelatih Kepala : ${headCoach.name}');
  print('Asisten        : ${asCoach.name}');
  print('Jumlah pemain  : ${team.players.length}');
  print('Pemain hadir   : ${ts.presentPlayers.map((p) => p.name).join(", ")}');
}
