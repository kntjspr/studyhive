import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  final List<StudyFile> _files = [
    StudyFile(
      name: "Math Notes.pdf",
      size: "2.4 MB",
      date: "Oct 15, 2023",
      type: FileType.pdf,
    ),
    StudyFile(
      name: "Biology Presentation.pptx",
      size: "5.7 MB",
      date: "Oct 12, 2023",
      type: FileType.presentation,
    ),
    StudyFile(
      name: "History Essay.docx",
      size: "1.2 MB",
      date: "Oct 10, 2023",
      type: FileType.document,
    ),
    StudyFile(
      name: "Physics Formulas.xlsx",
      size: "0.8 MB",
      date: "Oct 5, 2023",
      type: FileType.spreadsheet,
    ),
    StudyFile(
      name: "Literature References.txt",
      size: "0.3 MB",
      date: "Sep 28, 2023",
      type: FileType.text,
    ),
  ];

  String _currentFolder = "My Files";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF81D4FA),
        elevation: 0,
        title: Text(
          _currentFolder,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFolderTabs(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _files.length,
              itemBuilder: (context, index) {
                return _buildFileItem(_files[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadNewFile,
        backgroundColor: const Color(0xFF81D4FA),
        child: const Icon(Icons.upload_file),
      ),
    );
  }

  Widget _buildFolderTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF81D4FA).withOpacity(0.3),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFolderTab("My Files", isSelected: _currentFolder == "My Files"),
          _buildFolderTab("Shared", isSelected: _currentFolder == "Shared"),
          _buildFolderTab("Recent", isSelected: _currentFolder == "Recent"),
          _buildFolderTab("Favorites",
              isSelected: _currentFolder == "Favorites"),
        ],
      ),
    );
  }

  Widget _buildFolderTab(String name, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFolder = name;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF81D4FA) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileItem(StudyFile file) {
    IconData iconData;
    Color iconColor;

    switch (file.type) {
      case FileType.pdf:
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case FileType.presentation:
        iconData = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case FileType.document:
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case FileType.spreadsheet:
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case FileType.text:
        iconData = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 28,
          ),
        ),
        title: Text(
          file.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          "${file.size} • ${file.date}",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showFileOptions(file);
          },
        ),
        onTap: () {
          // Open file
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Opening ${file.name}")),
          );
        },
      ),
    );
  }

  void _showFileOptions(StudyFile file) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text("Download"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Downloading ${file.name}")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sharing ${file.name}")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Delete", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _files.remove(file);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${file.name} deleted")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _uploadNewFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Upload functionality would be implemented here")),
    );
  }
}

enum FileType { pdf, presentation, document, spreadsheet, text }

class StudyFile {
  final String name;
  final String size;
  final String date;
  final FileType type;

  StudyFile({
    required this.name,
    required this.size,
    required this.date,
    required this.type,
  });
}
