import 'package:flutter/material.dart';
import '../services/member_service.dart';

class MembersScreen extends StatefulWidget {
  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final _memberService = MemberService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openMemberForm(),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _memberService.fetchMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No members found.'));
          }
          final members = snapshot.data!;
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(member['name']),
                  subtitle: Text(member['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openMemberForm(
                          id: member['id'],
                          name: member['name'],
                          email: member['email'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _memberService.deleteMember(member['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Member deleted')));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openMemberForm({String? id, String? name, String? email}) async {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Member' : 'Edit Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Member Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Member Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _memberService.addMember(
                    nameController.text,
                    emailController.text,
                  );
                } else {
                  await _memberService.updateMember(
                    id,
                    nameController.text,
                    emailController.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
