// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/routes/route_manager.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/widgets/select_option_tile.dart';
import '../../../../../app/widgets/timer_count_down.dart';
import '../../../../../app/widgets/widgets.dart';
import '../../../../../config/app_logger.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/color.dart';
import '../../../../word/domain/entities/word_entity.dart';

class QuizEntity {
  final String word;
  final String question;
  final List<String> answers;
  String selectedAnswer;
  QuizEntity({
    required this.word,
    required this.question,
    required this.answers,
    this.selectedAnswer = '',
  });
}

class GameQuizPage extends StatefulWidget {
  const GameQuizPage({super.key, required this.words});

  final List<WordEntity> words;

  @override
  State<GameQuizPage> createState() => _GameQuizPageState();
}

class _GameQuizPageState extends State<GameQuizPage> {
  final ValueNotifier<int> currentQuestion = ValueNotifier(0);
  final ValueNotifier<int> selectedIndex = ValueNotifier(-1);
  late List<QuizEntity> quizs;
  late int timeDuration;

  @override
  void initState() {
    super.initState();

    timeDuration = AppValueConst.timeForQuiz * widget.words.length;
    final list = widget.words.map((e) => e.word).toList();
    quizs = List<QuizEntity>.generate(
      widget.words.length,
      (index) {
        final answers = List<String>.from(list)
          ..remove(widget.words[index].word)
          ..shuffle();

        return QuizEntity(
          word: widget.words[index].word,
          question:
              "(${widget.words[index].meanings.first.type.toLowerCase()}) ${widget.words[index].meanings.first.meaning}",
          answers: answers.take(3).toList()
            ..insert(
              Random().nextInt(4),
              widget.words[index].word,
            ),
        );
      },
    );
  }

  _onCompleteQuiz() {
    final point =
        quizs.where((element) => element.selectedAnswer == element.word).length;
    logger.i(point);
    context.pushReplacement(AppRoutes.quizSummery, extra: quizs);
  }

  void _onNextQuiz(int current) {
    if (current < quizs.length - 1) {
      if (quizs[current].selectedAnswer.isNotEmpty) {
        currentQuestion.value++;
        selectedIndex.value = -1;
      }
    } else {
      _onCompleteQuiz();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: context.colors.blue900.darken(.05),
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: currentQuestion,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: (value + 1) / quizs.length,
                      color: context.colors.green,
                      backgroundColor: context.colors.grey.withOpacity(.15),
                      borderRadius: BorderRadius.circular(8.r),
                      minHeight: 12.h,
                    );
                  },
                ),
                const Gap(height: 20),
                _buildCardQuestionAnswer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardQuestionAnswer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.theme.cardColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: ValueListenableBuilder(
        valueListenable: currentQuestion,
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.images.questionMark,
              height: 30.h,
              width: 30.w,
            ),
            const Gap(width: 8),
            Expanded(
              child: TextCustom(
                LocaleKeys.game_select_your_answer.tr(),
                style: context.textStyle.bodyS.grey,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TimeCountDownWidget(
                onFinish: () {
                  logger.i("STOP");
                },
                durationInSeconds: timeDuration,
                style: context.textStyle.caption.white,
              ),
            ),
          ],
        ),
        builder: (context, current, row) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              row!,
              const Gap(height: 10),
              TextCustom(
                "${quizs[current].question}.",
                textAlign: TextAlign.justify,
                maxLines: 10,
              ),
              const Gap(height: 15),
              ValueListenableBuilder(
                valueListenable: selectedIndex,
                builder: (context, selected, _) {
                  return Column(
                    children: quizs[current]
                        .answers
                        .mapIndexed((index, e) => SelectOptionTileWidget(
                              onTap: () {
                                quizs[current].selectedAnswer = e;
                                selectedIndex.value = index;
                              },
                              isSelected: quizs[current].selectedAnswer == e ||
                                  selected == index,
                              style: context.textStyle.bodyS.bw.bold,
                              text: e.toLowerCase(),
                            ))
                        .toList(),
                  );
                },
              ),
              const Gap(height: 15),
              _buildButtons(context, current),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButtons(BuildContext context, int current) {
    return SizedBox(
      width: context.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: current == 0
                ? const SizedBox()
                : TextButton(
                    onPressed: () {
                      currentQuestion.value--;
                      selectedIndex.value = -1;
                    },
                    child: TextCustom(
                      LocaleKeys.common_back.tr(),
                      style: context.textStyle.bodyM.bold.bw,
                    ),
                  ),
          ),
          ValueListenableBuilder(
            valueListenable: selectedIndex,
            builder: (context, selected, _) {
              return PushableButton(
                onPressed: () => _onNextQuiz(current),
                width: context.screenWidth / 3,
                type: quizs[current].selectedAnswer.isNotEmpty ||
                        current == quizs.length - 1
                    ? PushableButtonType.primary
                    : PushableButtonType.grey,
                text: current == quizs.length - 1
                    ? LocaleKeys.common_done.tr()
                    : LocaleKeys.common_next.tr(),
              );
            },
          ),
        ],
      ),
    );
  }

  AppBarCustom _buildAppBar(BuildContext context) {
    return AppBarCustom(
      transparent: true,
      // enablePadding: true,
      leading: BackButton(
        color: context.colors.white,
      ),
      title: ValueListenableBuilder(
        valueListenable: currentQuestion,
        builder: (context, value, _) {
          return TextCustom(
            LocaleKeys.game_question_th.tr(
              args: [(value + 1).toString(), quizs.length.toString()],
            ),
            style: context.textStyle.bodyM.bold.white,
            textAlign: TextAlign.center,
          );
        },
      ),
      action: Padding(
        padding: EdgeInsets.only(right: 5.w),
        child: ValueListenableBuilder(
          valueListenable: currentQuestion,
          builder: (context, value, _) {
            if (value >= quizs.length - 1) {
              return SizedBox(width: 60.w);
            }
            return TextButton(
              onPressed: () {
                currentQuestion.value++;
                selectedIndex.value = -1;
              },
              child: TextCustom(
                LocaleKeys.common_skip.tr(),
                style: context.textStyle.bodyS.white,
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
