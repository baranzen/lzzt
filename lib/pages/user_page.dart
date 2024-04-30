import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/firebase.dart';
import 'package:lzzt/widgets/bottom_sheet_widget.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ProfilePicture(),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bilgilerim',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                const SizedBox(height: 20),
                const UserInformations(),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Sifre Degistir'),
                  onPressed: () => bottomSheet(
                    (value) async {
                      await FireBase.changePassword(value, context);
                      Navigator.pop(context);
                    },
                    'Yeni sifre giriniz',
                    true,
                    TextInputType.text,
                    context,
                  ),
                ),
                const LogOutButton(),
                const DeleteAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return TextButton(
      child: const Text('Hesabi Sil'),
      onPressed: () async {
        await FireBase.deleteUserAccount(context).then((value) {
          ref.read(isAdminNotifierProvider.notifier).logOutAdmin();
        });
      },
    );
  }
}

class LogOutButton extends ConsumerWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return TextButton(
      onPressed: () async {
        await FireBase.logOut(context).then((value) {
          ref.read(isAdminNotifierProvider.notifier).logOutAdmin();
        });
      },
      child: const Text('cikis yap', style: TextStyle(color: Colors.red)),
    );
  }
}

class UserInformations extends StatefulWidget {
  const UserInformations({
    super.key,
  });

  @override
  State<UserInformations> createState() => _UserInformationsState();
}

class _UserInformationsState extends State<UserInformations> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: HexColor('#F3F5F7'),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FutureBuilder(
        future: FireBase.getUserData(),
        builder: (_, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('veri yok');
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Text('active');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Text('hata oluştu');
              }
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      //!email
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: snapshot.data!['email'],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      //!name
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          onChanged: (newValue) {
                            snapshot.data!['userName'] = newValue;
                          },
                          initialValue: snapshot.data!['userName'],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Ad',
                          ),
                          validator: (value) => value!.length < 3
                              ? 'En az 3 karakter olmali'
                              : null,
                        ),
                      ),
                      //!soyad
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          onChanged: (newValue) {
                            snapshot.data!['userSurname'] = newValue;
                          },
                          initialValue: snapshot.data!['userSurname'],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Soyad',
                          ),
                          validator: (value) => value!.length < 3
                              ? 'En az 3 karakter olmali'
                              : null,
                        ),
                      ),
                      //!telefon
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          onChanged: (newValue) {
                            snapshot.data!['userPhone'] = newValue;
                          },
                          initialValue: snapshot.data!['userPhone'],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Telefon',
                          ),
                          validator: (value) => value!.length < 11
                              ? 'En az 11 karakter olmali'
                              : null,
                        ),
                      ),
                      //!adres
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.streetAddress,
                          onChanged: (newValue) {
                            snapshot.data!['userAddress'] = newValue;
                          },
                          initialValue: snapshot.data!['userAddress'],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Adres',
                          ),
                          validator: (value) => value!.length < 10
                              ? 'En az 10 karakter olmali'
                              : null,
                        ),
                      ),

                      //! kaydet
                      ElevatedButton(
                        onPressed: () async {
                          bool validate = _formKey.currentState!.validate();
                          if (validate) {
                            _formKey.currentState!.save();
                            debugPrint('kaydediliyor');
                            await FireBase.changeUserData(
                              snapshot.data!['userName'],
                              snapshot.data!['userSurname'],
                              snapshot.data!['userPhone'],
                              snapshot.data!['userAddress'],
                              context,
                            );
                            _formKey.currentState!.reset();
                            setState(() {});
                          }
                        },
                        child: const Text(
                          'Kaydet',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return SizedBox(
      width: 200,
      child: InkWell(
        splashColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(500),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.network(
                user?.photoURL ?? AppHelper.defaultProfilePicture,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                    wasSynchronouslyLoaded
                        ? child
                        : AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                            child: child,
                          ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.5),
                child: const Text(
                  ' Değiştir',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          bottomSheet(
            (value) async {
              await FireBase.changeProfilePhoto(value, context);
              Navigator.pop(context);
              setState(() {});
            },
            'Resim URL',
            false,
            TextInputType.url,
            context,
          );
        },
      ),
    );
  }
}
