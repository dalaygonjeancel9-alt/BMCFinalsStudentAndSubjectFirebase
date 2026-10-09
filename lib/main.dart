import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// ---------- colors ----------
const pink = Color(0xFFEC4899);
const rose = Color(0xFFBE185D);
const blush = Color(0xFFFFF1F7);
const softPink = Color(0xFFFBCFE8);
const darkText = Color(0xFF4A1D35);
const mutedText = Color(0xFF9D5C7A);

const headerGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFF472B6), Color(0xFFDB2777), Color(0xFFBE185D)],
);

const buttonGradient = LinearGradient(
  colors: [Color(0xFFF472B6), Color(0xFFDB2777)],
);

// ---------- app ----------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // rounded border used by every text field
  OutlineInputBorder fieldBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subject Enrollment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: pink),
        scaffoldBackgroundColor: blush,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: blush,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(color: mutedText),
          floatingLabelStyle:
              const TextStyle(color: rose, fontWeight: FontWeight.w600),
          border: fieldBorder(softPink, 1.2),
          enabledBorder: fieldBorder(softPink, 1.2),
          focusedBorder: fieldBorder(pink, 2),
          errorBorder: fieldBorder(const Color(0xFFE11D48), 1.2),
          focusedErrorBorder: fieldBorder(const Color(0xFFE11D48), 2),
        ),
      ),
      home: const RegistrationScreen(),
    );
  }
}

// ---------- small reusable pieces ----------

// a plain circle, used for the decorative bubbles
Widget circle(double size, Color color) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

// text field with a pink icon and a "required" check
Widget pinkField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  String? hint,
  bool isLast = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      cursorColor: pink,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      style: const TextStyle(color: darkText, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFD7A9BF)),
        prefixIcon: Icon(icon, color: pink),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
    ),
  );
}

// full-width button with the pink gradient
// (shows a spinner and ignores taps while `loading` is true)
Widget pinkButton(
  String label,
  IconData icon,
  VoidCallback onTap, {
  bool loading = false,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: buttonGradient,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          color: Color(0x66EC4899),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: loading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: loading
                ? const [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ]
                : [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(icon, color: Colors.white, size: 20),
                  ],
          ),
        ),
      ),
    ),
  );
}

// little pink circle with a number inside
Widget numberBadge(int number) {
  return Container(
    width: 32,
    height: 32,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: buttonGradient,
    ),
    child: Center(
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// small rounded tag with an icon and text
Widget infoChip(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: blush,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: softPink),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: pink),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: rose,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

// light box that holds one subject on the enrollment screen
Widget subjectBox(int number, List<Widget> fields) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF8FB),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: softPink),
    ),
    child: Column(
      children: [
        Row(
          children: [
            numberBadge(number),
            const SizedBox(width: 10),
            Text(
              'Subject $number',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: rose,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...fields,
      ],
    ),
  );
}

// ---------- page frame: pink header + white card ----------
class PageFrame extends StatelessWidget {
  final int step; // 0, 1 or 2
  final String title;
  final String subtitle;
  final Widget child;

  const PageFrame({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  // one dot of the Register / Enroll / Verify progress bar
  Widget stepDot(int i) {
    const labels = ['Register', 'Enroll', 'Verify'];
    bool done = i < step;
    bool active = i == step;

    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (done || active) ? Colors.white : const Color(0x33FFFFFF),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check_rounded, color: rose, size: 20)
                : Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: active ? rose : Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          labels[i],
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            color: active ? Colors.white : const Color(0xCCFFFFFF),
          ),
        ),
      ],
    );
  }

  // the three dots with a line between each
  Widget stepBar() {
    List<Widget> items = [];
    for (int i = 0; i < 3; i++) {
      if (i > 0) {
        items.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i <= step ? Colors.white : const Color(0x44FFFFFF),
                ),
              ),
            ),
          ),
        );
      }
      items.add(stepDot(i));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canGoBack = Navigator.of(context).canPop();

    return Scaffold(
      body: Stack(
        children: [
          // curved pink header
          Container(
            height: 310,
            decoration: const BoxDecoration(
              gradient: headerGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
            ),
          ),

          // decorative bubbles
          Positioned(top: -50, right: -30, child: circle(170, const Color(0x22FFFFFF))),
          Positioned(top: 110, left: -60, child: circle(130, const Color(0x1AFFFFFF))),
          Positioned(top: 40, right: 90, child: circle(40, const Color(0x22FFFFFF))),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // back arrow (only when there is a screen to go back to)
                SizedBox(
                  height: 52,
                  child: canGoBack
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),

                // title, subtitle and progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xDDFFFFFF),
                        ),
                      ),
                      const SizedBox(height: 18),
                      stepBar(),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // white card with the page content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33EC4899),
                            blurRadius: 30,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
//  SCREEN 1 - USER REGISTRATION
// =================================================================
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final sectionController = TextEditingController();
  final courseController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    sectionController.dispose();
    courseController.dispose();
    super.dispose();
  }

  void goNext() {
    // stop if any field is empty
    if (!formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnrollmentScreen(
          name: nameController.text.trim(),
          section: sectionController.text.trim(),
          course: courseController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      step: 0,
      title: 'Welcome!',
      subtitle: 'Global Reciprocal College Enrollement Form',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            pinkField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person_rounded,
            ),
            pinkField(
              controller: sectionController,
              label: 'Section',
              icon: Icons.groups_rounded,
            ),
            pinkField(
              controller: courseController,
              label: 'Course',
              icon: Icons.school_rounded,
              isLast: true,
            ),
            const SizedBox(height: 6),
            pinkButton('Next', Icons.arrow_forward_rounded, goNext),
          ],
        ),
      ),
    );
  }
}

// =================================================================
//  SCREEN 2 - SUBJECT ENROLLMENT
// =================================================================
class EnrollmentScreen extends StatefulWidget {
  final String name;
  final String section;
  final String course;

  const EnrollmentScreen({
    super.key,
    required this.name,
    required this.section,
    required this.course,
  });

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  final formKey = GlobalKey<FormState>();
  final subject1Controller = TextEditingController();
  final time1Controller = TextEditingController();
  final subject2Controller = TextEditingController();
  final time2Controller = TextEditingController();

  @override
  void dispose() {
    subject1Controller.dispose();
    time1Controller.dispose();
    subject2Controller.dispose();
    time2Controller.dispose();
    super.dispose();
  }

  void goNext() {
    if (!formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(
          name: widget.name,
          section: widget.section,
          course: widget.course,
          subject1: subject1Controller.text.trim(),
          time1: time1Controller.text.trim(),
          subject2: subject2Controller.text.trim(),
          time2: time2Controller.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      step: 1,
      title: 'Enroll Subjects',
      subtitle: 'Add your subjects and schedules',
      child: Form(
        key: formKey,
        child: Column(
          children: [
            subjectBox(1, [
              pinkField(
                controller: subject1Controller,
                label: 'Subject',
                icon: Icons.menu_book_rounded,
              ),
              pinkField(
                controller: time1Controller,
                label: 'Time',
                hint: 'e.g. 2-5 PM',
                icon: Icons.access_time_rounded,
              ),
            ]),
            subjectBox(2, [
              pinkField(
                controller: subject2Controller,
                label: 'Subject',
                icon: Icons.menu_book_rounded,
              ),
              pinkField(
                controller: time2Controller,
                label: 'Time',
                hint: 'e.g. 5-8 PM',
                icon: Icons.access_time_rounded,
                isLast: true,
              ),
            ]),
            pinkButton('Next', Icons.arrow_forward_rounded, goNext),
          ],
        ),
      ),
    );
  }
}

// =================================================================
//  SCREEN 3 - SUBJECT VERIFICATION (saves to Firestore)
// =================================================================
class VerificationScreen extends StatefulWidget {
  final String name;
  final String section;
  final String course;
  final String subject1;
  final String time1;
  final String subject2;
  final String time2;

  const VerificationScreen({
    super.key,
    required this.name,
    required this.section,
    required this.course,
    required this.subject1,
    required this.time1,
    required this.subject2,
    required this.time2,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool saving = false;

  // first letter of the first and last name, e.g. "Juan Dela Cruz" -> "JC"
  String getInitials() {
    List<String> words =
        widget.name.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  // writes one document to the "enrollments" collection in Firestore
  Future<void> saveEnrollment() async {
    setState(() => saving = true);

    try {
      await FirebaseFirestore.instance.collection('enrollments').add({
        'name': widget.name,
        'section': widget.section,
        'course': widget.course,
        'subjects': [
          {'subject': widget.subject1, 'time': widget.time1},
          {'subject': widget.subject2, 'time': widget.time2},
        ],
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      setState(() => saving = false);
      showSavedDialog(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: rose,
          behavior: SnackBarBehavior.floating,
          content: Text('Could not save: $e'),
        ),
      );
    }
  }

  // one row showing a subject and its time
  Widget subjectTile(int number, String subject, String time) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8FB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: softPink),
      ),
      child: Row(
        children: [
          numberBadge(number),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 6),
                infoChip(Icons.access_time_rounded, time),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: pink),
        ],
      ),
    );
  }

  // the "All Saved!" popup
  void showSavedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0x99BE185D),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: headerGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x66EC4899),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'All Saved!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: rose,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your enrollment has been saved successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: mutedText),
                ),
                const SizedBox(height: 22),
                pinkButton('Done', Icons.done_all_rounded, () {
                  Navigator.of(dialogContext).pop(); // close popup
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      step: 2,
      title: 'Verify Details',
      subtitle: 'Global Reciprocal College Enrollement Form',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avatar + name + chips
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: headerGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x55EC4899),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    getInitials(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        infoChip(Icons.groups_rounded, 'Section ${widget.section}'),
                        infoChip(Icons.school_rounded, widget.course),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),
          const Row(
            children: [
              Icon(Icons.auto_stories_rounded, color: pink, size: 20),
              SizedBox(width: 8),
              Text(
                'Enrolled Subjects',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: rose,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          subjectTile(1, widget.subject1, widget.time1),
          subjectTile(2, widget.subject2, widget.time2),

          const SizedBox(height: 10),
          pinkButton(
            'Save',
            Icons.save_rounded,
            saveEnrollment,
            loading: saving,
          ),
          const SizedBox(height: 6),
          Center(
            child: TextButton(
              onPressed: saving ? null : () => Navigator.of(context).pop(),
              child: const Text(
                'Go back and edit',
                style: TextStyle(color: rose, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}