
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color background = Color(0xFFFFF8F8);
  static const Color textColor = Color(0xFF604A50);
  static const Color pink = Color(0xFFD88FA5);
  static const Color pinkDark = Color(0xFFC98098);
  static const Color mutedText = Color(0xFF9B838B);
  static const Color borderColor = Color(0xFFF1E2E6);

  // Dane demonstracyjne. Później pobierzemy je z backendu.
  String _name = 'Użytkownik';
  String _email = 'uzytkownik@example.com';

  final List<String> _interestOptions = [
    'Ruch i sport',
    'Relaks i odpoczynek',
    'Aktywności kreatywne',
    'Spotkania z innymi',
    'Nauka i rozwój',
    'Aktywności na świeżym powietrzu',
  ];

  final Set<String> _selectedInterests = {};

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: textColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _openPage(String title, Widget child) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: Text(
              title,
              style: const TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: background,
            foregroundColor: textColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          body: SafeArea(child: child),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF947780),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    final color = destructive
        ? const Color(0xFFBD777E)
        : pinkDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: destructive
                    ? const Color(0xFFFBEAEC)
                    : const Color(0xFFF9E8ED),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                size: 21,
                color: color,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFB9A6AC),
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 70,
                endIndent: 15,
                color: Color(0xFFF7EFF2),
              ),
          ],
        ],
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: pinkDark,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: mutedText),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: pink,
          width: 1.5,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  // ZARZĄDZANIE KONTEM

  void _openAccountManagement() {
    final nameController =
        TextEditingController(text: _name);
    final emailController =
        TextEditingController(text: _email);

    _openPage(
      'Zarządzanie kontem',
      ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Dane osobowe',
            style: TextStyle(
              color: textColor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tutaj możesz zmienić swoje imię '
            'oraz adres e-mail.',
            style: TextStyle(
              color: mutedText,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),

          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration('Imię'),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('Adres e-mail'),
          ),

          const SizedBox(height: 20),

          _primaryButton(
            label: 'Zapisz zmiany',
            onPressed: () {
              final newName = nameController.text.trim();
              final newEmail = emailController.text.trim();

              if (newName.isEmpty ||
                  !newEmail.contains('@') ||
                  !newEmail.contains('.')) {
                _showMessage(
                  'Wpisz imię i poprawny adres e-mail',
                );
                return;
              }

              // Docelowo dane zapisze backend.
              _showMessage(
                'Zmiana danych konta będzie dostępna '
                'po podłączeniu backendu',
              );
            },
          ),

          const SizedBox(height: 30),

          const Divider(color: borderColor),

          const SizedBox(height: 22),

          const Text(
            'Bezpieczeństwo',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: borderColor),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.lock_outline_rounded,
                color: pinkDark,
              ),
              title: const Text(
                'Zmień hasło',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: mutedText,
              ),
              onTap: _openChangePassword,
            ),
          ),
        ],
      ),
    );
  }

  void _openChangePassword() {
    _openPage(
      'Zmiana hasła',
      const _ChangePasswordForm(),
    );
  }

  // ZAINTERESOWANIA

  void _openInterests() {
    final temporarySelection =
        Set<String>.from(_selectedInterests);

    _openPage(
      'Moje zainteresowania',
      StatefulBuilder(
        builder: (pageContext, setPageState) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Co Cię interesuje?',
                style: TextStyle(
                  color: textColor,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Wybierz rodzaje aktywności, które lubisz '
                'lub chciałabyś wypróbować. '
                'Możesz zaznaczyć kilka odpowiedzi.',
                style: TextStyle(
                  color: mutedText,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    for (final interest
                        in _interestOptions) ...[
                      CheckboxListTile(
                        value: temporarySelection
                            .contains(interest),
                        onChanged: (value) {
                          setPageState(() {
                            if (value == true) {
                              temporarySelection.add(interest);
                            } else {
                              temporarySelection.remove(interest);
                            }
                          });
                        },
                        title: Text(
                          interest,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                        activeColor: pinkDark,
                        checkColor: Colors.white,
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 23),

              _primaryButton(
                label: 'Zapisz preferencje',
                onPressed: () {
                  // Działa lokalnie, bez backendu.
                  setState(() {
                    _selectedInterests
                      ..clear()
                      ..addAll(temporarySelection);
                  });

                  Navigator.of(pageContext).pop();

                  _showMessage(
                    'Zapisano zainteresowania w aplikacji',
                  );
                },
              ),

              const SizedBox(height: 14),

              const Text(
                'Wybór jest opcjonalny. Możesz wrócić '
                'i zmienić zainteresowania w dowolnym momencie.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedText,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // POMOC I KONTAKT

  void _openHelp() {
    _openPage(
      'Pomoc i kontakt',
      ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Jak możemy pomóc?',
            style: TextStyle(
              color: textColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Jeśli masz pytania dotyczące korzystania '
            'z aplikacji lub chcesz zgłosić problem, '
            'możesz skontaktować się z zespołem wsparcia.',
            style: TextStyle(
              color: mutedText,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.mail_outline_rounded,
                  color: pinkDark,
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Text(
                    'Kontakt e-mail z pomocą techniczną',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          _primaryButton(
            label: 'Skontaktuj się',
            onPressed: () {
              _showMessage(
                'Dane kontaktowe uzupełnimy '
                'przed udostępnieniem aplikacji',
              );
            },
          ),
        ],
      ),
    );
  }

  // PRYWATNOŚĆ I REGULAMIN

  void _openPrivacy() {
    _openPage(
      'Prywatność i regulamin',
      ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Dokumenty aplikacji',
            style: TextStyle(
              color: textColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Tutaj znajdziesz informacje o przetwarzaniu '
            'danych oraz zasadach korzystania z aplikacji.',
            style: TextStyle(
              color: mutedText,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 23),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.shield_outlined,
                    color: pinkDark,
                  ),
                  title: const Text(
                    'Polityka prywatności',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: mutedText,
                  ),
                  onTap: () {
                    _openDocumentPlaceholder(
                      'Polityka prywatności',
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 55,
                  endIndent: 15,
                  color: borderColor,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    color: pinkDark,
                  ),
                  title: const Text(
                    'Regulamin',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: mutedText,
                  ),
                  onTap: () {
                    _openDocumentPlaceholder('Regulamin');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDocumentPlaceholder(String title) {
    _openPage(
      title,
      Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.description_outlined,
                color: pink,
                size: 46,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Treść dokumentu zostanie '
                'uzupełniona przed publikacją aplikacji.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedText,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CZYSZCZENIE DANYCH

  Future<void> _confirmClearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Wyczyścić dane?',
            style: TextStyle(color: textColor),
          ),
          content: const Text(
            'Ta operacja docelowo usunie historię '
            'aktywności, oceny samopoczucia oraz '
            'zapisane pomysły. Konto pozostanie aktywne.',
            style: TextStyle(
              color: mutedText,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Anuluj',
                style: TextStyle(color: mutedText),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Wyczyść dane',
                style: TextStyle(
                  color: Color(0xFFBD777E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    // Bez backendu niczego nie usuwamy.
    _showMessage(
      'Czyszczenie danych będzie dostępne '
      'po podłączeniu backendu',
    );
  }

  // WYLOGOWANIE

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Wylogować się?',
            style: TextStyle(color: textColor),
          ),
          content: const Text(
            'Czy na pewno chcesz wylogować się '
            'z aplikacji?',
            style: TextStyle(color: mutedText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Anuluj',
                style: TextStyle(color: mutedText),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Wyloguj',
                style: TextStyle(
                  color: pinkDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    // Później zakończymy sesję użytkownika.
    _showMessage(
      'Wylogowanie podłączymy '
      'po przygotowaniu logowania',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20, 20, 20, 35,
          ),
          children: [
            const Text(
              'Ustawienia',
              style: TextStyle(
                color: textColor,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            _sectionTitle('Konto'),

            _settingsGroup([
              _settingsItem(
                icon: Icons.person_outline_rounded,
                title: 'Zarządzanie kontem',
                subtitle: 'Imię, adres e-mail i hasło',
                onTap: _openAccountManagement,
              ),
              _settingsItem(
                icon: Icons.favorite_border_rounded,
                title: 'Moje zainteresowania',
                subtitle: 'Preferowane rodzaje aktywności',
                onTap: _openInterests,
              ),
            ]),

            const SizedBox(height: 25),

            _sectionTitle('Pomoc i informacje'),

            _settingsGroup([
              _settingsItem(
                icon: Icons.help_outline_rounded,
                title: 'Pomoc i kontakt',
                subtitle: 'Wsparcie i pytania',
                onTap: _openHelp,
              ),
              _settingsItem(
                icon: Icons.shield_outlined,
                title: 'Prywatność i regulamin',
                subtitle:
                    'Polityka prywatności i warunki korzystania',
                onTap: _openPrivacy,
              ),
            ]),

            const SizedBox(height: 25),

            _sectionTitle('Dane i bezpieczeństwo'),

            _settingsGroup([
              _settingsItem(
                icon: Icons.delete_outline_rounded,
                title: 'Wyczyść moje dane',
                subtitle:
                    'Usuń historię i zapisane aktywności',
                onTap: _confirmClearData,
                destructive: true,
              ),
              _settingsItem(
                icon: Icons.logout_rounded,
                title: 'Wyloguj się',
                subtitle: 'Zakończ bieżącą sesję',
                onTap: _confirmLogout,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// Oddzielny formularz zmiany hasła.
// Na razie wyłącznie interfejs.

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm();

  @override
  State<_ChangePasswordForm> createState() =>
      _ChangePasswordFormState();
}

class _ChangePasswordFormState
    extends State<_ChangePasswordForm> {
  static const Color textColor = Color(0xFF604A50);
  static const Color pinkDark = Color(0xFFC98098);
  static const Color mutedText = Color(0xFF9B838B);

  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool hidden,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: hidden,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: mutedText),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFF1E2E6),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFF1E2E6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: pinkDark,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            hidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: mutedText,
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_currentPassword.text.isEmpty ||
        _newPassword.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      _showMessage('Uzupełnij wszystkie pola');
      return;
    }

    if (_newPassword.text != _confirmPassword.text) {
      _showMessage('Nowe hasła nie są identyczne');
      return;
    }

    _showMessage(
      'Zmiana hasła będzie dostępna '
      'po podłączeniu backendu',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: textColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Zmień hasło',
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 9),

        const Text(
          'Wprowadź obecne hasło, a następnie '
          'ustaw nowe.',
          style: TextStyle(
            color: mutedText,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 22),

        _passwordField(
          label: 'Obecne hasło',
          controller: _currentPassword,
          hidden: _hideCurrent,
          toggleVisibility: () {
            setState(() => _hideCurrent = !_hideCurrent);
          },
        ),

        const SizedBox(height: 15),

        _passwordField(
          label: 'Nowe hasło',
          controller: _newPassword,
          hidden: _hideNew,
          toggleVisibility: () {
            setState(() => _hideNew = !_hideNew);
          },
        ),

        const SizedBox(height: 15),

        _passwordField(
          label: 'Powtórz nowe hasło',
          controller: _confirmPassword,
          hidden: _hideConfirm,
          toggleVisibility: () {
            setState(() => _hideConfirm = !_hideConfirm);
          },
        ),

        const SizedBox(height: 23),

        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkDark,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Zmień hasło',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
