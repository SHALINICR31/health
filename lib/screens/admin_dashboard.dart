import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isAdmin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  Future<void> checkAdmin() async {
    var currentUser = _auth.currentUser;
    if (currentUser == null) {
      debugPrint("No user logged in");
      setState(() => isLoading = false);
      return;
    }

    try {
      await currentUser.getIdToken(true);
      var adminDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (adminDoc.exists && adminDoc.data()?['role'] == "admin") {
        setState(() => isAdmin = true);
      }
    } catch (e) {
      debugPrint("Error fetching admin role: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Stream<QuerySnapshot> getUsersByStatus(bool verified) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('verified', isEqualTo: verified)
        .where('role', whereIn: ["doctor", "lab_technician"])
        .snapshots();
  }

  void approveUser(String userId) async {
    if (!isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are not an admin!")),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'verified': true,
        'approvedAt': FieldValue.serverTimestamp(),
      });
      debugPrint("User Approved: $userId");
    } catch (e) {
      debugPrint("Error approving user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void rejectUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'rejected': true,
        'verified': false,
      });
      debugPrint("User Rejected: $userId");
    } catch (e) {
      debugPrint("Error rejecting user: $e");
    }
  }

  void activateVoiceCommand() {
    debugPrint("Voice Command Activated");
    // Implement AI-powered voice command functionality here
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Accepted"),
              Tab(text: "Rejected"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: activateVoiceCommand,
          child: const Icon(Icons.mic),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isAdmin
            ? TabBarView(
          children: [
            buildUserList(getUsersByStatus(false)),
            buildUserList(getUsersByStatus(true)),
            buildRejectedUserList(),
          ],
        )
            : const Center(
          child: Text("You are not authorized to access this page."),
        ),
      ),
    );
  }

  Widget buildUserList(Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        var users = snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return ListTile(
              title: Text(user['email']),
              subtitle: Text("Role: ${user['role']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => approveUser(user.id),
                    child: const Text("Approve"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => rejectUser(user.id),
                    child: const Text("Reject"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildRejectedUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('rejected', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No rejected users"));
        }

        var users = snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return ListTile(
              title: Text(user['email']),
              subtitle: Text("Role: ${user['role']}"),
            );
          },
        );
      },
    );
  }
}
