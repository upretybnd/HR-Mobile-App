import 'package:flutter/material.dart';
import 'package:hr_management/core/utils/app_colors.dart';
import 'package:hr_management/core/widgets/main_layout.dart';

class DashboardMain extends StatefulWidget {
  const DashboardMain({super.key});

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                  children: [
                    dbContainer(
                      label: 'TOTAL EMPLOYEES',number: '123', text: '+4 this month',color: AppColors.primary,
                    ),
                    dbContainer(
                      label: 'ACTIVE INTERNS', number: '13', text: '3 expiring soon', color: AppColors.warning,
                    ),
                    dbContainer(
                      label: 'ATTENDANCE TODAY', number: '89%', text: '+2% Vs Yesterday', color: AppColors.primaryLight,
                    ),
                    dbContainer(
                      label: 'PENDING LEAVES',number: '8', text: '2 Urgent',color: AppColors.secondary,
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Segmented Donut Chart Card
                ListTile(
                  contentPadding: EdgeInsets.zero, 
                  title: Text('Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_forward, size: 14, color: AppColors.primary)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CustomPaint(
                          painter: SegmentedDonutPainter(
                            segments: [
                              DonutSegment(
                                value: 0.50, color: AppColors.primaryDark,
                              ),
                              DonutSegment(
                                value: 0.20, color: AppColors.secondaryLight,
                              ),
                              DonutSegment(
                                value: 0.15, color: AppColors.warning,
                              ),
                              DonutSegment(
                                value: 0.15,color: AppColors.primaryLight,
                              ),
                            ],
                            strokeWidth: 14,
                            gapDegrees: 4,
                          ),
                          child: Center(
                            child: Text(
                              '89%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            donutSideData(
                              color: AppColors.primary, text: 'Surakshya - 50%',
                            ),

                            SizedBox(height: 5),

                            donutSideData(
                              color: AppColors.secondaryLight, text: 'Prakash - 20%',
                            ),

                            SizedBox(height: 5),

                            donutSideData(
                              color: AppColors.warning, text: 'Others - 20%',
                            ),

                            SizedBox(height: 5),

                            donutSideData(
                              color: AppColors.primaryLight, text: 'Rest - 10%',
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 10,),

                ListTile(
                  contentPadding: EdgeInsets.zero, 
                  title: Text('Department Count', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_forward, size: 14, color: AppColors.primary)
                    ],
                  ),
                ),

                // Department Count Linear Progress Bars
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DepartmentProgressBar(title: 'Engineering', count: '42', value: 42/50, color: AppColors.primaryDark),
                      DepartmentProgressBar(title: 'Sales', count: '28', value: 28/50, color:AppColors.primaryDark),
                      DepartmentProgressBar(title: 'Marketing', count: '20', value: 20/50, color: AppColors.primaryDark),
                      DepartmentProgressBar(title: 'Design', count: '14', value: 14/50, color: AppColors.primaryDark),
                    ],
                  ),
                ),

                SizedBox(height: 10,),

                ListTile(
                  contentPadding: EdgeInsets.zero, 
                  title: Text('Recent Activities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_forward, size: 14, color: AppColors.primary)
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      recentActivities(color: AppColors.primaryLight, label: 'Surakshya completed her design task', text: '10 mins ago'),
                      SizedBox(height: 10,),
                      recentActivities(color: AppColors.secondaryLight, label: 'Prakash flagged absent no attendence', text: '4 mins ago')
                    ],
                  ) ,
                ),

                SizedBox(height: 10,),

                ListTile(
                  contentPadding: EdgeInsets.zero, 
                  title: Text('Announcement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_forward, size: 14, color: AppColors.primary)
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      announcement(color: AppColors.secondary, label: 'Office clouser in June 17', text: 'Eid public holiday.Company wide',data: 'PINNED',),
                      SizedBox(height: 10,),
                      announcement(color: Colors.black, label: 'All hand on June 19', text: 'Review of all task. All staffs',data: 'URGENT',)
                    ],
                  ) ,
                ),
                SizedBox(height:30),
              ],
            ),
          ),
        ),
    );
  }
}

// dbMain top container
class dbContainer extends StatelessWidget {
  final String label;
  final String number;
  final String text;
  final color;
  const dbContainer({
    super.key,
    required this.label,
    required this.number,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(height: 4, width: double.infinity, color: color),
          // Content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text( label,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text( number,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text( text,
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Donut Segment Data
class DonutSegment {
  final double value;
  final Color color;
  const DonutSegment({required this.value, required this.color});
}

// Segmented Donut Chart Painter
class SegmentedDonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double strokeWidth;
  final double gapDegrees;

  SegmentedDonutPainter({
    required this.segments,
    this.strokeWidth = 14,
    this.gapDegrees = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final totalGap = gapDegrees * segments.length;
    final availableDegrees = 360.0 - totalGap;

    double startAngle = -90.0; // Start from the top

    for (final segment in segments) {
      final sweepAngle = availableDegrees * segment.value;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degToRad(startAngle),
        _degToRad(sweepAngle),
        false,
        paint,
      );
      startAngle += sweepAngle + gapDegrees;
    }
  }

  double _degToRad(double deg) => deg * 3.141592653589793 / 180;

  @override
  bool shouldRepaint(covariant SegmentedDonutPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gapDegrees != gapDegrees;
  }
}

// Donut side data
class donutSideData extends StatelessWidget {
  final color;
  final String text;
  const donutSideData({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
        ),

        SizedBox(width: 8),

        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Department Progress Bar
class DepartmentProgressBar extends StatelessWidget {
  final String title;
  final String count;
  final double value;
  final Color color;

  const DepartmentProgressBar({
    super.key,
    required this.title,
    required this.count,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text(count, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AppColors.disabled.withValues(alpha:0.3),
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}

class recentActivities extends StatelessWidget {
  final color;
  final String label;
  final String text;
  const recentActivities({super.key, required this.color,required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(color: color,
          borderRadius: BorderRadius.circular(50)),
        ),

        SizedBox(width: 10,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            SizedBox(height: 3,),
            Text(text, style: TextStyle(fontSize: 12,color: AppColors.disabledText),)
          ],
        )
      ],
    );
  }
}

class announcement extends StatelessWidget {
  final color;
  final String label;
  final String data;
  final String text;
  const announcement({super.key, required this.color,required this.label, required this.text, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height:18 ,
          width: 80,
          decoration: BoxDecoration(color: color,
          borderRadius: BorderRadius.circular(16)),
          child: Align(
            alignment:Alignment.center,
            child: Text(data, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: AppColors.scaffoldBg),)),
        ),

        SizedBox(width: 10,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            SizedBox(height: 3,),
            Text(text, style: TextStyle(fontSize: 12,color: AppColors.disabledText),)
          ],
        )
      ],
    );
  }
}