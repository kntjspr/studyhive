import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFF9A),
              Color(0xFFFFC164),
              Color(0xFFFFFF9A),
            ],
            stops: [0.111, 0.326, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 20),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.black87,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Group Meetings",
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Meeting Categories
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryHeader("GROUP DISCUSSION:"),
                      const SizedBox(height: 12),
                      _buildMeetingCard(
                        context: context,
                        title: "Mobile Development",
                        time: "10:00 AM",
                        participants: 4,
                        isLive: true,
                        backgroundImage:
                            "assets/images/meetings/meeting_card_bg1.png",
                      ),
                      const SizedBox(height: 32),
                      _buildCategoryHeader("FDS MEETING:"),
                      const SizedBox(height: 12),
                      _buildMeetingCard(
                        context: context,
                        title: "Data Structures",
                        time: "2:00 PM",
                        participants: 6,
                        isLive: false,
                        backgroundImage:
                            "assets/images/meetings/meeting_card_bg2.png",
                      ),
                      const SizedBox(height: 32),
                      _buildCategoryHeader("STATS MEETING:"),
                      const SizedBox(height: 12),
                      _buildMeetingCard(
                        context: context,
                        title: "Statistical Analysis",
                        time: "4:30 PM",
                        participants: 5,
                        isLive: false,
                        backgroundImage:
                            "assets/images/meetings/meeting_card_bg3.png",
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.black.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _buildMeetingCard({
    required BuildContext context,
    required String title,
    required String time,
    required int participants,
    required bool isLive,
    required String backgroundImage,
  }) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.5),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3D00).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3D00),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "LIVE",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Participant avatars
                SizedBox(
                  width: 120,
                  height: 32,
                  child: Stack(
                    children: List.generate(
                      participants > 4 ? 4 : participants,
                      (index) => Positioned(
                        left: index * 20.0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/avatar${index + 1}.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Join button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9900),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    "Join",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
