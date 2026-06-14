import 'package:flutter/material.dart';
import '../game/battle_game.dart';



class CreditsOverlay extends StatefulWidget {
  const CreditsOverlay({super.key, required this.game});

  final BattleGame game;

  @override
  State<CreditsOverlay> createState() => _CreditsOverlayState();
}

class _CreditsOverlayState extends State<CreditsOverlay> {
  static const List<_Developer> _developers = [
    _Developer(name: 'Ahmad Rafi', npm: '1062502', photoPath: 'assets/images/rafi.jpg'),
    _Developer(name: 'Jeki Setiawan', npm: '1062510', photoPath: 'assets/images/jeki.jpg'),
    _Developer(name: 'Nur Ihsan Habibi', npm: '1062521', photoPath: 'assets/images/habibi.jpg'),
    _Developer(name: 'M. Ridwan Aldo,S', npm: '1062514', photoPath: 'assets/images/riduan.jpg'),
    _Developer(name: 'M. Fatir', npm: '1062518', photoPath: 'assets/images/fatir.jpg'),
    _Developer(name: 'M. Diko Mulia', npm: '1062518', photoPath: 'assets/images/dikko.jpg'),
  ];

  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int next) {
    if (next < 0 || next >= _developers.length) return;
    setState(() => _index = next);
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            // Background 
            Positioned.fill(
              child: IgnorePointer(
                child: Container(color: Colors.black.withOpacity(0.10)),
              ),
            ),

            // Back button
            Positioned(
              left: 8,
              top: 6,
              child: IconButton(
                tooltip: 'Back',
                onPressed: () => widget.game.closeCredits(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            // Tombol Sinopsis 
            Positioned( 
              right: 8, 
              top: 6, 
              child: IconButton( 
                tooltip: 'Sinopsis',
                 onPressed: () { widget.game.overlays.add('Sinopsis'); }, 
                 icon: const Icon(Icons.article, 
                 color: Colors.white), 
                 ),
                  ),

            // card carousel
            Center(
              child: SizedBox(
                height: 380,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _developers.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _DeveloperCard(dev: _developers[i]),
                  ),
                ),
              ),
            ),

            // panah kiri
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _ArrowButton(
                  direction: AxisDirection.left,
                  enabled: _index > 0,
                  onTap: () => _goTo(_index - 1),
                ),
              ),
            ),

            // panah kanan
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _ArrowButton(
                  direction: AxisDirection.right,
                  enabled: _index < _developers.length - 1,
                  onTap: () => _goTo(_index + 1),
                ),
              ),
            ),

            // Index indicator
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_index + 1} / ${_developers.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Developer 
class _Developer {
  const _Developer({
    required this.name,
    required this.npm,
    this.photoPath,
  });

  final String name;
  final String npm;
  final String? photoPath;
}

/// Developer card 
class _DeveloperCard extends StatelessWidget {
  const _DeveloperCard({required this.dev});
  final _Developer dev;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(26),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        children: [
          _DeveloperAvatar(dev: dev),
          const Spacer(),
          Text(
            'NAMA: ${dev.name.toUpperCase()}',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'NPM: ${dev.npm}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// Developer avatar
class _DeveloperAvatar extends StatelessWidget {
  const _DeveloperAvatar({required this.dev});
  final _Developer dev;

  @override
  Widget build(BuildContext context) {
    const double size = 190;
    if (dev.photoPath == null) {
      return Icon(Icons.person, size: size, color: Colors.black);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.asset(
        dev.photoPath!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// panah button widget
class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.direction,
    required this.enabled,
    required this.onTap,
  });

  final AxisDirection direction;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = direction == AxisDirection.left ? Icons.arrow_left : Icons.arrow_right;

    return Opacity(
      opacity: enabled ? 1 : 0.25,
      child: InkResponse(
        onTap: enabled ? onTap : null,
        radius: 30,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 40, color: Colors.white),
        ),
      ),
    );
  }
}
class SinopsisOverlay extends StatefulWidget {
  final BattleGame game;
  const SinopsisOverlay({super.key, required this.game});

  @override
  State<SinopsisOverlay> createState() => _SinopsisOverlayState();
}

class _SinopsisOverlayState extends State<SinopsisOverlay> {
  late final ScrollController _scrollController;

  

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Scroll otomatis ke bawah
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 20), // durasi scroll
        curve: Curves.linear,
      ).then((_) {
     // kosong karena sebelumnya mau memunculkan audio saat anunya selesai
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: SafeArea(
        child: Column(
          children: [
            // Tombol back
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  widget.game.overlays.remove('Sinopsis');
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: const Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '''
SINOPSIS GAME

Di sebuah dunia fantasi, para petani, penombak, dan pendekar
berjuang mempertahankan desa dari serangan musuh.
Setiap kemenangan membuka tantangan baru,
disertai kuis pengetahuan umum untuk menguji kecerdasan pemain.

Game ini dibuat oleh tim developer dengan penuh semangat,
dan menggunakan audio latar "Epic Battle Theme" untuk menambah suasana.
                    ''',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


