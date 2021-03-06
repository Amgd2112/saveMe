import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/mixins/validation_mixins.dart';
import '../../../../modules/save_me/repositories/user_auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserAuthRepository _userRepository;
  SignUpBloc({UserAuthRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpState.initial());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpEmailChange)
      yield* _mapSignUpEmailChangeToState(event.email);
    else if (event is SignUpNameChange)
      yield* _mapSignUpNameChangeToState(event.userName);
    else if (event is SignUpPasswordChange)
      yield* _mapSignUpPasswordChangeToState(event.password);
    else if (event is SignUpSubmitted)
      yield* _mapSignUpSubmittedToState(
        email: event.email,
        userName: event.userName,
        password: event.password,
      );
  }

  Stream<SignUpState> _mapSignUpEmailChangeToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email) == null,
    );
  }

  Stream<SignUpState> _mapSignUpPasswordChangeToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password) == null,
    );
  }

  Stream<SignUpState> _mapSignUpNameChangeToState(String userName) async* {
    yield state.update(
      isNameValid: Validators.isValidUserName(userName) == null,
    );
  }

  Stream<SignUpState> _mapSignUpSubmittedToState({
    @required String email,
    @required String password,
    @required String userName,
  }) async* {
    yield SignUpState.loading();

    try {
      await _userRepository.singUpWithCredentials(
        email: email,
        userName: userName,
        password: password,
      );
      yield SignUpState.success();
    } catch (error) {
      yield SignUpState.failure();
    }
  }
}
