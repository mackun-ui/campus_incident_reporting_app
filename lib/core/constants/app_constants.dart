class AppConstants {
  static const allowedEmailDomains = ['alustudent.com', 'alueducation.com'];
  static const roleStudent = 'student';
  static const roleStaff = 'staff';

  static const categories = ['Facilities', 'Water', 'Electricity', 'Safety', 'Sanitation'];

  static const locations = [
    'Student Residence', 'Learning Commons', 'Social Commons', 'Enterprise Commons', 'Basketball Court', 'Other',
  ];

  static const statusSubmitted = 'submitted';
  static const statusInProgress = 'in_progress';
  static const statusResolved = 'resolved';
  static const statuses = [statusSubmitted, statusInProgress, statusResolved];
  
  static const cloudinaryCloudName = 'tvpwvfgb';
  static const cloudinaryUploadPreset = 'campus_incidents';
}