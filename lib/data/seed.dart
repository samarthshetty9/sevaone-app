import 'package:flutter/material.dart';

import 'models.dart';

/// Everything below is fictional demo data. Service names come from the
/// SevaOne portal catalogue, but fees, people, IDs, bills, centres and readings
/// are invented.
const citizenName = L('Ananya Gowda', 'ಅನನ್ಯಾ ಗೌಡ');
const citizenMobile = '98XXXXX210';
const citizenDistrict = L('Bengaluru Urban', 'ಬೆಂಗಳೂರು ನಗರ');

const _revenue = L('Revenue Department', 'ಕಂದಾಯ ಇಲಾಖೆ');
const _transport = L('Transport Department', 'ಸಾರಿಗೆ ಇಲಾಖೆ');
const _wcd = L('Women and Child Development', 'ಮಹಿಳಾ ಮತ್ತು ಮಕ್ಕಳ ಅಭಿವೃದ್ಧಿ');
const _pension = L('Social Security and Pensions', 'ಸಾಮಾಜಿಕ ಭದ್ರತೆ ಮತ್ತು ಪಿಂಚಣಿ');
const _education = L('Education Department', 'ಶಿಕ್ಷಣ ಇಲಾಖೆ');
const _agri = L('Agriculture Department', 'ಕೃಷಿ ಇಲಾಖೆ');
const _health = L('Suvarna Arogya Suraksha Trust', 'ಸುವರ್ಣ ಆರೋಗ್ಯ ಸುರಕ್ಷಾ ಟ್ರಸ್ಟ್');
const _food = L('Food and Civil Supplies', 'ಆಹಾರ ಮತ್ತು ನಾಗರಿಕ ಸರಬರಾಜು');
const _rdpr = L('Rural Development and Panchayat Raj', 'ಗ್ರಾಮೀಣಾಭಿವೃದ್ಧಿ ಮತ್ತು ಪಂಚಾಯತ್ ರಾಜ್');
const _disabled =
    L('Differently Abled and Senior Citizens', 'ವಿಕಲಚೇತನರು ಮತ್ತು ಹಿರಿಯ ನಾಗರಿಕರು');

const _catCert = L('Certificates', 'ಪ್ರಮಾಣಪತ್ರಗಳು');
const _catTransport = L('Transport', 'ಸಾರಿಗೆ');
const _catLand = L('Land and Property', 'ಭೂಮಿ ಮತ್ತು ಆಸ್ತಿ');
const _catFood = L('Food and Ration', 'ಆಹಾರ ಮತ್ತು ಪಡಿತರ');
const _catRural = L('Rural Services', 'ಗ್ರಾಮೀಣ ಸೇವೆಗಳು');
const _catWomen = L('Women and Children', 'ಮಹಿಳೆ ಮತ್ತು ಮಕ್ಕಳು');
const _catPension = L('Pensions', 'ಪಿಂಚಣಿ');
const _catEdu = L('Education', 'ಶಿಕ್ಷಣ');
const _catHealth = L('Health', 'ಆರೋಗ್ಯ');
const _catFarm = L('Farmers', 'ರೈತರು');

final List<Service> services = [
  const Service(
    code: 'SVC001',
    name: L('Income Certificate', 'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರ'),
    dept: _revenue,
    category: _catCert,
    desc: L('Official proof of annual family income for scholarships, schemes and reservations.',
        'ವಿದ್ಯಾರ್ಥಿವೇತನ, ಯೋಜನೆಗಳು ಮತ್ತು ಮೀಸಲಾತಿಗಾಗಿ ವಾರ್ಷಿಕ ಕುಟುಂಬ ಆದಾಯದ ಅಧಿಕೃತ ಪುರಾವೆ.'),
    fee: 40,
    sakalaDays: 21,
    docs: ['aadhaar', 'ration', 'pan'],
    source: 'Sakala',
    icon: Icons.account_balance_wallet_outlined,
    featured: true,
  ),
  const Service(
    code: 'SVC002',
    name: L('Caste Certificate', 'ಜಾತಿ ಪ್ರಮಾಣಪತ್ರ'),
    dept: _revenue,
    category: _catCert,
    desc: L('Certificate of caste category for education, employment and welfare benefits.',
        'ಶಿಕ್ಷಣ, ಉದ್ಯೋಗ ಮತ್ತು ಕಲ್ಯಾಣ ಸೌಲಭ್ಯಗಳಿಗಾಗಿ ಜಾತಿ ವರ್ಗದ ಪ್ರಮಾಣಪತ್ರ.'),
    fee: 40,
    sakalaDays: 21,
    docs: ['aadhaar', 'ration'],
    source: 'Sakala',
    icon: Icons.badge_outlined,
    featured: true,
  ),
  const Service(
    code: 'SVC003',
    name: L('Residence Certificate', 'ವಾಸಸ್ಥಳ ಪ್ರಮಾಣಪತ್ರ'),
    dept: _revenue,
    category: _catCert,
    desc: L('Proof that you live at your current address in Karnataka.',
        'ಕರ್ನಾಟಕದಲ್ಲಿ ನಿಮ್ಮ ಪ್ರಸ್ತುತ ವಿಳಾಸದಲ್ಲಿ ವಾಸಿಸುತ್ತಿರುವುದರ ಪುರಾವೆ.'),
    fee: 40,
    sakalaDays: 15,
    docs: ['aadhaar', 'ration'],
    source: 'Sakala',
    icon: Icons.home_outlined,
    featured: true,
  ),
  const Service(
    code: 'SVC010',
    name: L('Birth Certificate', 'ಜನನ ಪ್ರಮಾಣಪತ್ರ'),
    dept: _revenue,
    category: _catCert,
    desc: L('Get a certified copy of a registered birth record.',
        'ನೋಂದಾಯಿತ ಜನನ ದಾಖಲೆಯ ಪ್ರಮಾಣೀಕೃತ ಪ್ರತಿಯನ್ನು ಪಡೆಯಿರಿ.'),
    fee: 20,
    sakalaDays: 7,
    docs: ['aadhaar'],
    icon: Icons.child_care_outlined,
  ),
  const Service(
    code: 'SVC011',
    name: L('Marriage Certificate', 'ವಿವಾಹ ಪ್ರಮಾಣಪತ್ರ'),
    dept: _revenue,
    category: _catCert,
    desc: L('Register a marriage and get the certificate.',
        'ವಿವಾಹವನ್ನು ನೋಂದಾಯಿಸಿ ಪ್ರಮಾಣಪತ್ರ ಪಡೆಯಿರಿ.'),
    fee: 100,
    sakalaDays: 15,
    docs: ['aadhaar', 'pan'],
    icon: Icons.favorite_border,
  ),
  const Service(
    code: 'SVC020',
    name: L('Learner Licence', 'ಕಲಿಕಾ ಚಾಲನಾ ಪರವಾನಗಿ'),
    dept: _transport,
    category: _catTransport,
    desc: L('Apply for a learner driving licence and book a test.',
        'ಕಲಿಕಾ ಚಾಲನಾ ಪರವಾನಗಿಗೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ ಮತ್ತು ಪರೀಕ್ಷೆ ಕಾಯ್ದಿರಿಸಿ.'),
    fee: 200,
    sakalaDays: 7,
    docs: ['aadhaar'],
    icon: Icons.drive_eta_outlined,
    featured: true,
  ),
  const Service(
    code: 'SVC021',
    name: L('Driving Licence Renewal', 'ಚಾಲನಾ ಪರವಾನಗಿ ನವೀಕರಣ'),
    dept: _transport,
    category: _catTransport,
    desc: L('Renew an expiring driving licence.', 'ಅವಧಿ ಮುಗಿಯುತ್ತಿರುವ ಚಾಲನಾ ಪರವಾನಗಿಯನ್ನು ನವೀಕರಿಸಿ.'),
    fee: 400,
    sakalaDays: 15,
    docs: ['aadhaar', 'dl'],
    icon: Icons.autorenew,
  ),
  const Service(
    code: 'SVC030',
    name: L('Land Record (RTC)', 'ಭೂ ದಾಖಲೆ (ಪಹಣಿ)'),
    dept: _revenue,
    category: _catLand,
    desc: L('View and download the Record of Rights, Tenancy and Crops.',
        'ಹಕ್ಕು, ಹಿಡುವಳಿ ಮತ್ತು ಬೆಳೆ ದಾಖಲೆಯನ್ನು ನೋಡಿ ಮತ್ತು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ.'),
    fee: 15,
    sakalaDays: 1,
    docs: ['aadhaar'],
    icon: Icons.landscape_outlined,
    featured: true,
  ),
  const Service(
    code: 'SVC031',
    name: L('Mutation Register Extract', 'ಮ್ಯುಟೇಷನ್ ದಾಖಲೆ ಪ್ರತಿ'),
    dept: _revenue,
    category: _catLand,
    desc: L('Get an extract of land ownership changes.', 'ಭೂ ಮಾಲೀಕತ್ವ ಬದಲಾವಣೆಗಳ ಪ್ರತಿ ಪಡೆಯಿರಿ.'),
    fee: 25,
    sakalaDays: 7,
    docs: ['aadhaar'],
    icon: Icons.map_outlined,
  ),
  const Service(
    code: 'SVC040',
    name: L('New Ration Card', 'ಹೊಸ ಪಡಿತರ ಚೀಟಿ'),
    dept: _food,
    category: _catFood,
    desc: L('Apply for a new BPL or APL ration card for your family.',
        'ನಿಮ್ಮ ಕುಟುಂಬಕ್ಕೆ ಹೊಸ ಬಿಪಿಎಲ್ ಅಥವಾ ಎಪಿಎಲ್ ಪಡಿತರ ಚೀಟಿಗೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ.'),
    fee: 100,
    sakalaDays: 30,
    docs: ['aadhaar', 'income'],
    icon: Icons.rice_bowl_outlined,
  ),
  const Service(
    code: 'SVC050',
    name: L('Issuance of Student Bus Pass', 'ವಿದ್ಯಾರ್ಥಿ ಬಸ್ ಪಾಸ್ ವಿತರಣೆ'),
    dept: L('Bangalore Metropolitan Transport Corporation', 'ಬೆಂಗಳೂರು ಮಹಾನಗರ ಸಾರಿಗೆ ಸಂಸ್ಥೆ'),
    category: _catTransport,
    desc: L('Concessional bus pass for students.', 'ವಿದ್ಯಾರ್ಥಿಗಳಿಗೆ ರಿಯಾಯಿತಿ ಬಸ್ ಪಾಸ್.'),
    fee: 150,
    sakalaDays: 7,
    docs: ['aadhaar', 'marks'],
    icon: Icons.directions_bus_outlined,
  ),
  const Service(
    code: 'SVC060',
    name: L('Trade Licence', 'ವ್ಯಾಪಾರ ಪರವಾನಗಿ'),
    dept: _rdpr,
    category: _catRural,
    desc: L('Licence for running a small business in a Gram Panchayat area.',
        'ಗ್ರಾಮ ಪಂಚಾಯಿತಿ ವ್ಯಾಪ್ತಿಯಲ್ಲಿ ಸಣ್ಣ ವ್ಯಾಪಾರ ನಡೆಸಲು ಪರವಾನಗಿ.'),
    fee: 250,
    sakalaDays: 15,
    docs: ['aadhaar', 'pan'],
    icon: Icons.storefront_outlined,
  ),
];

bool _women(CitizenProfile p) => p.gender == 'female';

final List<Service> schemes = [
  Service(
    code: 'SCH5135',
    name: const L('Gruha Lakshmi', 'ಗೃಹ ಲಕ್ಷ್ಮಿ'),
    dept: _wcd,
    category: _catWomen,
    desc: const L('Monthly assistance for the woman head of a family.',
        'ಕುಟುಂಬದ ಮಹಿಳಾ ಮುಖ್ಯಸ್ಥೆಗೆ ಮಾಸಿಕ ನೆರವು.'),
    benefit: const L('₹2,000 per month', 'ತಿಂಗಳಿಗೆ ₹2,000'),
    docs: const ['aadhaar', 'ration'],
    isScheme: true,
    icon: Icons.volunteer_activism_outlined,
    featured: true,
    rule: (p) => _women(p) && p.bpl,
    ruleText: const L('Woman head of family with a ration card',
        'ಪಡಿತರ ಚೀಟಿ ಹೊಂದಿರುವ ಕುಟುಂಬದ ಮಹಿಳಾ ಮುಖ್ಯಸ್ಥೆ'),
  ),
  Service(
    code: 'SCH404',
    name: const L('Manaswini Yojane', 'ಮನಸ್ವಿನಿ ಯೋಜನೆ'),
    dept: _pension,
    category: _catPension,
    desc: const L('Monthly pension for unmarried or divorced women.',
        'ಅವಿವಾಹಿತ ಅಥವಾ ವಿಚ್ಛೇದಿತ ಮಹಿಳೆಯರಿಗೆ ಮಾಸಿಕ ಪಿಂಚಣಿ.'),
    benefit: const L('₹800 per month', 'ತಿಂಗಳಿಗೆ ₹800'),
    fee: 30,
    docs: const ['aadhaar', 'income'],
    isScheme: true,
    icon: Icons.woman_outlined,
    rule: (p) => _women(p) && p.age >= 40 && p.income <= 200000,
    ruleText: const L('Women aged 40+ with income under ₹2 lakh',
        '₹2 ಲಕ್ಷಕ್ಕಿಂತ ಕಡಿಮೆ ಆದಾಯದ 40+ ವಯಸ್ಸಿನ ಮಹಿಳೆಯರು'),
  ),
  Service(
    code: 'SCH407',
    name: const L('Farmer Widow Pension', 'ರೈತ ವಿಧವಾ ಪಿಂಚಣಿ'),
    dept: _pension,
    category: _catPension,
    desc: const L('Monthly pension for widows of farmers.', 'ರೈತರ ವಿಧವೆಯರಿಗೆ ಮಾಸಿಕ ಪಿಂಚಣಿ.'),
    benefit: const L('₹2,000 per month', 'ತಿಂಗಳಿಗೆ ₹2,000'),
    fee: 30,
    docs: const ['aadhaar', 'income'],
    isScheme: true,
    icon: Icons.agriculture_outlined,
    rule: (p) => _women(p) && p.occupation == 'farmer',
    ruleText: const L('Widows of farmers', 'ರೈತರ ವಿಧವೆಯರು'),
  ),
  Service(
    code: 'SCH410',
    name: const L('Old Age Pension', 'ವೃದ್ಧಾಪ್ಯ ವೇತನ'),
    dept: _pension,
    category: _catPension,
    desc: const L('Monthly pension for senior citizens with low income.',
        'ಕಡಿಮೆ ಆದಾಯದ ಹಿರಿಯ ನಾಗರಿಕರಿಗೆ ಮಾಸಿಕ ಪಿಂಚಣಿ.'),
    benefit: const L('₹1,200 per month', 'ತಿಂಗಳಿಗೆ ₹1,200'),
    fee: 30,
    docs: const ['aadhaar', 'income'],
    isScheme: true,
    icon: Icons.elderly_outlined,
    featured: true,
    rule: (p) => p.age >= 60 && p.income <= 200000,
    ruleText: const L('Age 60+ with income under ₹2 lakh',
        '₹2 ಲಕ್ಷಕ್ಕಿಂತ ಕಡಿಮೆ ಆದಾಯದ 60+ ವಯಸ್ಸಿನವರು'),
  ),
  Service(
    code: 'SCH412',
    name: const L('Disability Pension', 'ಅಂಗವಿಕಲ ವೇತನ'),
    dept: _disabled,
    category: _catPension,
    desc: const L('Monthly pension for persons with disabilities.',
        'ವಿಕಲಚೇತನರಿಗೆ ಮಾಸಿಕ ಪಿಂಚಣಿ.'),
    benefit: const L('₹1,400 per month', 'ತಿಂಗಳಿಗೆ ₹1,400'),
    docs: const ['aadhaar', 'income'],
    isScheme: true,
    icon: Icons.accessible_outlined,
    rule: (p) => p.disabled,
    ruleText: const L('Persons with 40% or more disability', '40% ಅಥವಾ ಹೆಚ್ಚಿನ ಅಂಗವೈಕಲ್ಯ ಇರುವವರು'),
  ),
  Service(
    code: 'SCH7200',
    name: const L('Chief Minister Raitha Vidyanidhi', 'ಮುಖ್ಯಮಂತ್ರಿ ರೈತ ವಿದ್ಯಾನಿಧಿ'),
    dept: _education,
    category: _catEdu,
    desc: const L('Scholarship for children of farmers.', 'ರೈತರ ಮಕ್ಕಳಿಗೆ ವಿದ್ಯಾರ್ಥಿವೇತನ.'),
    benefit: const L('Up to ₹11,000 per year', 'ವರ್ಷಕ್ಕೆ ₹11,000 ವರೆಗೆ'),
    docs: const ['aadhaar', 'marks', 'income'],
    isScheme: true,
    icon: Icons.school_outlined,
    featured: true,
    rule: (p) => p.occupation == 'farmer' || p.occupation == 'student',
    ruleText: const L('Students from farmer families', 'ರೈತ ಕುಟುಂಬಗಳ ವಿದ್ಯಾರ್ಥಿಗಳು'),
  ),
  Service(
    code: 'SCH7300',
    name: const L('Post-Matric Scholarship', 'ಮೆಟ್ರಿಕ್ ನಂತರದ ವಿದ್ಯಾರ್ಥಿವೇತನ'),
    dept: _education,
    category: _catEdu,
    desc: const L('Fee support and maintenance allowance for reserved categories.',
        'ಮೀಸಲು ವರ್ಗದವರಿಗೆ ಶುಲ್ಕ ನೆರವು ಮತ್ತು ನಿರ್ವಹಣಾ ಭತ್ಯೆ.'),
    benefit: const L('Full tuition fee support', 'ಸಂಪೂರ್ಣ ಬೋಧನಾ ಶುಲ್ಕ ನೆರವು'),
    docs: const ['aadhaar', 'marks', 'income'],
    isScheme: true,
    icon: Icons.menu_book_outlined,
    rule: (p) => p.occupation == 'student' && p.category != 'general',
    ruleText: const L('SC, ST, OBC or minority students',
        'ಎಸ್‌ಸಿ, ಎಸ್‌ಟಿ, ಒಬಿಸಿ ಅಥವಾ ಅಲ್ಪಸಂಖ್ಯಾತ ವಿದ್ಯಾರ್ಥಿಗಳು'),
  ),
  Service(
    code: 'SCH8000',
    name: const L('Ayushman Bharat – Arogya Karnataka', 'ಆಯುಷ್ಮಾನ್ ಭಾರತ್ – ಆರೋಗ್ಯ ಕರ್ನಾಟಕ'),
    dept: _health,
    category: _catHealth,
    desc: const L('Cashless hospital treatment for eligible families.',
        'ಅರ್ಹ ಕುಟುಂಬಗಳಿಗೆ ನಗದುರಹಿತ ಆಸ್ಪತ್ರೆ ಚಿಕಿತ್ಸೆ.'),
    benefit: const L('Up to ₹5 lakh per family per year', 'ವರ್ಷಕ್ಕೆ ಪ್ರತಿ ಕುಟುಂಬಕ್ಕೆ ₹5 ಲಕ್ಷ ವರೆಗೆ'),
    docs: const ['aadhaar', 'ration'],
    isScheme: true,
    icon: Icons.local_hospital_outlined,
    featured: true,
    rule: (p) => p.bpl,
    ruleText: const L('Families with a BPL ration card', 'ಬಿಪಿಎಲ್ ಪಡಿತರ ಚೀಟಿ ಹೊಂದಿರುವ ಕುಟುಂಬಗಳು'),
  ),
  Service(
    code: 'SCH8100',
    name: const L('Raitha Siri', 'ರೈತ ಸಿರಿ'),
    dept: _agri,
    category: _catFarm,
    desc: const L('Per-hectare support for farmers growing millets.',
        'ಸಿರಿಧಾನ್ಯ ಬೆಳೆಯುವ ರೈತರಿಗೆ ಪ್ರತಿ ಹೆಕ್ಟೇರ್‌ಗೆ ನೆರವು.'),
    benefit: const L('₹10,000 per hectare', 'ಪ್ರತಿ ಹೆಕ್ಟೇರ್‌ಗೆ ₹10,000'),
    docs: const ['aadhaar'],
    isScheme: true,
    icon: Icons.grass_outlined,
    rule: (p) => p.occupation == 'farmer',
    ruleText: const L('Farmers growing millets', 'ಸಿರಿಧಾನ್ಯ ಬೆಳೆಯುವ ರೈತರು'),
  ),
  Service(
    code: 'SCH8200',
    name: const L('Mathru Vandana', 'ಮಾತೃ ವಂದನಾ'),
    dept: _wcd,
    category: _catWomen,
    desc: const L('Maternity benefit for pregnant and nursing mothers.',
        'ಗರ್ಭಿಣಿ ಮತ್ತು ಹಾಲುಣಿಸುವ ತಾಯಂದಿರಿಗೆ ಹೆರಿಗೆ ಸೌಲಭ್ಯ.'),
    benefit: const L('₹5,000 in instalments', 'ಕಂತುಗಳಲ್ಲಿ ₹5,000'),
    docs: const ['aadhaar'],
    isScheme: true,
    icon: Icons.pregnant_woman_outlined,
    rule: (p) => _women(p) && p.age >= 18 && p.age <= 45,
    ruleText: const L('Pregnant women aged 18+', '18+ ವಯಸ್ಸಿನ ಗರ್ಭಿಣಿಯರು'),
  ),
  Service(
    code: 'SCH8300',
    name: const L('Yuva Nidhi', 'ಯುವ ನಿಧಿ'),
    dept: const L('Skill Development', 'ಕೌಶಲ್ಯ ಅಭಿವೃದ್ಧಿ'),
    category: _catEdu,
    desc: const L('Monthly allowance for unemployed graduates and diploma holders.',
        'ನಿರುದ್ಯೋಗಿ ಪದವೀಧರರು ಮತ್ತು ಡಿಪ್ಲೊಮಾ ಹೊಂದಿರುವವರಿಗೆ ಮಾಸಿಕ ಭತ್ಯೆ.'),
    benefit: const L('₹1,500–₹3,000 per month', 'ತಿಂಗಳಿಗೆ ₹1,500–₹3,000'),
    docs: const ['aadhaar', 'marks'],
    isScheme: true,
    icon: Icons.work_outline,
    rule: (p) => p.occupation == 'unemployed' && p.age <= 35,
    ruleText: const L('Unemployed graduates up to age 35', '35 ವರ್ಷದವರೆಗಿನ ನಿರುದ್ಯೋಗಿ ಪದವೀಧರರು'),
  ),
];

const docTypes = <DocType>[
  DocType('aadhaar', L('Aadhaar', 'ಆಧಾರ್'), L('UIDAI', 'ಯುಐಡಿಎಐ'), Icons.fingerprint,
      'XXXX XXXX 4821',
      downloadable: false),
  DocType('pan', L('PAN Card', 'ಪ್ಯಾನ್ ಕಾರ್ಡ್'), L('Income Tax Department', 'ಆದಾಯ ತೆರಿಗೆ ಇಲಾಖೆ'),
      Icons.credit_card, 'ABCDE1234F'),
  DocType('dl', L('Driving Licence', 'ಚಾಲನಾ ಪರವಾನಗಿ'),
      L('Transport Department', 'ಸಾರಿಗೆ ಇಲಾಖೆ'), Icons.drive_eta_outlined, 'KA01 20190012345'),
  // The plan's improvement: wider DigiLocker document access.
  DocType('ration', L('Ration Card', 'ಪಡಿತರ ಚೀಟಿ'),
      L('Food and Civil Supplies', 'ಆಹಾರ ಮತ್ತು ನಾಗರಿಕ ಸರಬರಾಜು'), Icons.rice_bowl_outlined,
      'KA-BPL-29-004417'),
  DocType('income', L('Income Certificate', 'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರ'),
      L('Revenue Department', 'ಕಂದಾಯ ಇಲಾಖೆ'), Icons.account_balance_wallet_outlined,
      'RD0041225000918'),
  DocType('marks', L('SSLC Marks Card', 'ಎಸ್‌ಎಸ್‌ಎಲ್‌ಸಿ ಅಂಕಪಟ್ಟಿ'),
      L('KSEAB', 'ಕೆಎಸ್‌ಇಎಬಿ'), Icons.school_outlined, 'SSLC-2008-552190'),
  DocType('rc', L('Vehicle RC', 'ವಾಹನ ಆರ್‌ಸಿ'),
      L('Transport Department', 'ಸಾರಿಗೆ ಇಲಾಖೆ'), Icons.two_wheeler_outlined, 'KA05 MX 2241'),
];

DocType docById(String id) => docTypes.firstWhere((d) => d.id == id);

/// Documents the existing production DigiLocker integration already returns.
const coreDocIds = ['aadhaar', 'dl', 'pan'];

List<TrackStage> revenueStages(DateTime start) => [
      TrackStage(const L('Application submitted', 'ಅರ್ಜಿ ಸಲ್ಲಿಸಲಾಗಿದೆ'), at: start),
      const TrackStage(L('Document check', 'ದಾಖಲೆ ಪರಿಶೀಲನೆ'),
          note: L('Auto-verified from DigiLocker', 'ಡಿಜಿಲಾಕರ್‌ನಿಂದ ಸ್ವಯಂ ಪರಿಶೀಲಿಸಲಾಗಿದೆ')),
      const TrackStage(L('Village Accountant review', 'ಗ್ರಾಮ ಲೆಕ್ಕಿಗರ ಪರಿಶೀಲನೆ')),
      const TrackStage(L('Tahsildar approval', 'ತಹಶೀಲ್ದಾರ್ ಅನುಮೋದನೆ')),
      const TrackStage(L('Certificate issued', 'ಪ್ರಮಾಣಪತ್ರ ವಿತರಿಸಲಾಗಿದೆ')),
    ];

List<Application> seedApplications() {
  final now = DateTime.now();
  return [
    Application(
      id: 'KAR-REV-2026-104512',
      service: const L('Income Certificate', 'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರ'),
      dept: _revenue,
      source: AppSource.servicePlus,
      submitted: now.subtract(const Duration(days: 6)),
      sakalaDays: 21,
      stages: revenueStages(now.subtract(const Duration(days: 6))),
      current: 2,
    ),
    Application(
      id: 'SKL-GSC-2026-778120',
      service: const L('Residence Certificate', 'ವಾಸಸ್ಥಳ ಪ್ರಮಾಣಪತ್ರ'),
      dept: _revenue,
      source: AppSource.sakala,
      submitted: now.subtract(const Duration(days: 19)),
      sakalaDays: 15,
      stages: revenueStages(now.subtract(const Duration(days: 19))),
      current: 4,
    ),
  ];
}

/// IDs anyone can look up in the tracker, including ones not filed in the app.
final Map<String, Application> lookupOnly = () {
  final now = DateTime.now();
  return {
    'TKN-8842-1190': Application(
      id: 'TKN-8842-1190',
      service: const L('Learner Licence', 'ಕಲಿಕಾ ಚಾಲನಾ ಪರವಾನಗಿ'),
      dept: _transport,
      source: AppSource.token,
      submitted: now.subtract(const Duration(days: 3)),
      sakalaDays: 7,
      stages: [
        TrackStage(const L('Token issued at counter', 'ಕೌಂಟರ್‌ನಲ್ಲಿ ಟೋಕನ್ ನೀಡಲಾಗಿದೆ'),
            at: now.subtract(const Duration(days: 3))),
        const TrackStage(L('Forwarded to RTO', 'ಆರ್‌ಟಿಒಗೆ ರವಾನಿಸಲಾಗಿದೆ')),
        const TrackStage(L('Test scheduled', 'ಪರೀಕ್ಷೆ ನಿಗದಿಯಾಗಿದೆ')),
        const TrackStage(L('Licence issued', 'ಪರವಾನಗಿ ವಿತರಿಸಲಾಗಿದೆ')),
      ],
      current: 1,
    ),
  };
}();

List<Bill> seedBills() {
  final now = DateTime.now();
  return [
    Bill(
      id: 'b1',
      provider: const L('BESCOM', 'ಬೆಸ್ಕಾಂ'),
      category: 'electricity',
      consumerNo: '7342019865',
      label: const L('Home electricity', 'ಮನೆ ವಿದ್ಯುತ್'),
      amount: 1284,
      due: now.add(const Duration(days: 3)),
    ),
    Bill(
      id: 'b2',
      provider: const L('BWSSB', 'ಬಿಡಬ್ಲ್ಯುಎಸ್‌ಎಸ್‌ಬಿ'),
      category: 'water',
      consumerNo: 'W-229-11840',
      label: const L('Home water', 'ಮನೆ ನೀರು'),
      amount: 462,
      due: now.add(const Duration(days: 9)),
    ),
    Bill(
      id: 'b3',
      provider: const L('Bengaluru Property Tax', 'ಬೆಂಗಳೂರು ಆಸ್ತಿ ತೆರಿಗೆ'),
      category: 'property',
      consumerNo: 'SAS-0091-44213',
      label: const L('Property tax 2026–27', 'ಆಸ್ತಿ ತೆರಿಗೆ 2026–27'),
      amount: 6120,
      due: now.add(const Duration(days: 24)),
    ),
  ];
}

class BillProvider {
  final L name;
  final String category;
  const BillProvider(this.name, this.category);
}

const billProviders = <BillProvider>[
  BillProvider(L('BESCOM', 'ಬೆಸ್ಕಾಂ'), 'electricity'),
  BillProvider(L('MESCOM', 'ಮೆಸ್ಕಾಂ'), 'electricity'),
  BillProvider(L('HESCOM', 'ಹೆಸ್ಕಾಂ'), 'electricity'),
  BillProvider(L('GESCOM', 'ಜೆಸ್ಕಾಂ'), 'electricity'),
  BillProvider(L('CESC Mysuru', 'ಸೆಸ್ಕ್ ಮೈಸೂರು'), 'electricity'),
  BillProvider(L('BWSSB', 'ಬಿಡಬ್ಲ್ಯುಎಸ್‌ಎಸ್‌ಬಿ'), 'water'),
  BillProvider(L('Mysuru City Water', 'ಮೈಸೂರು ನಗರ ನೀರು'), 'water'),
  BillProvider(L('Hubballi-Dharwad Water', 'ಹುಬ್ಬಳ್ಳಿ-ಧಾರವಾಡ ನೀರು'), 'water'),
  BillProvider(L('Gram Panchayat Water', 'ಗ್ರಾಮ ಪಂಚಾಯಿತಿ ನೀರು'), 'water'),
  BillProvider(L('Bengaluru Property Tax', 'ಬೆಂಗಳೂರು ಆಸ್ತಿ ತೆರಿಗೆ'), 'property'),
  BillProvider(L('GP Property Tax', 'ಗ್ರಾಮ ಪಂಚಾಯಿತಿ ಆಸ್ತಿ ತೆರಿಗೆ'), 'property'),
];

const centres = <Centre>[
  Centre('c1', 'Karnataka One', L('Karnataka One – Malleshwaram', 'ಕರ್ನಾಟಕ ಒನ್ – ಮಲ್ಲೇಶ್ವರಂ'),
      L('Near 8th Cross, Malleshwaram, Bengaluru', '8ನೇ ಅಡ್ಡರಸ್ತೆ ಬಳಿ, ಮಲ್ಲೇಶ್ವರಂ, ಬೆಂಗಳೂರು'),
      citizenDistrict, 1.8, '8:00 AM – 7:00 PM', 1, Offset(0.42, 0.34), '080-0000-1001'),
  Centre('c2', 'Karnataka One', L('Karnataka One – Jayanagar', 'ಕರ್ನಾಟಕ ಒನ್ – ಜಯನಗರ'),
      L('4th Block, Jayanagar, Bengaluru', '4ನೇ ಬ್ಲಾಕ್, ಜಯನಗರ, ಬೆಂಗಳೂರು'),
      citizenDistrict, 3.6, '8:00 AM – 7:00 PM', 2, Offset(0.5, 0.68), '080-0000-1002'),
  Centre('c3', 'Karnataka One', L('Karnataka One – Indiranagar', 'ಕರ್ನಾಟಕ ಒನ್ – ಇಂದಿರಾನಗರ'),
      L('100 Feet Road, Indiranagar, Bengaluru', '100 ಅಡಿ ರಸ್ತೆ, ಇಂದಿರಾನಗರ, ಬೆಂಗಳೂರು'),
      citizenDistrict, 5.2, '8:00 AM – 7:00 PM', 0, Offset(0.74, 0.46), '080-0000-1003'),
  Centre('c4', 'GramaOne', L('GramaOne – Hoskote', 'ಗ್ರಾಮ ಒನ್ – ಹೊಸಕೋಟೆ'),
      L('Gram Panchayat Office, Hoskote', 'ಗ್ರಾಮ ಪಂಚಾಯಿತಿ ಕಚೇರಿ, ಹೊಸಕೋಟೆ'),
      L('Bengaluru Rural', 'ಬೆಂಗಳೂರು ಗ್ರಾಮಾಂತರ'), 8.4, '9:00 AM – 5:30 PM', 0, Offset(0.87, 0.24),
      '080-0000-1004'),
  Centre('c5', 'GramaOne', L('GramaOne – Nelamangala', 'ಗ್ರಾಮ ಒನ್ – ನೆಲಮಂಗಲ'),
      L('Near Bus Stand, Nelamangala', 'ಬಸ್ ನಿಲ್ದಾಣದ ಬಳಿ, ನೆಲಮಂಗಲ'),
      L('Bengaluru Rural', 'ಬೆಂಗಳೂರು ಗ್ರಾಮಾಂತರ'), 11.1, '9:00 AM – 5:30 PM', 1, Offset(0.14, 0.2),
      '080-0000-1005'),
  Centre('c6', 'GramaOne', L('GramaOne – Devanahalli', 'ಗ್ರಾಮ ಒನ್ – ದೇವನಹಳ್ಳಿ'),
      L('Market Road, Devanahalli', 'ಮಾರುಕಟ್ಟೆ ರಸ್ತೆ, ದೇವನಹಳ್ಳಿ'),
      L('Bengaluru Rural', 'ಬೆಂಗಳೂರು ಗ್ರಾಮಾಂತರ'), 14.7, '9:00 AM – 5:30 PM', 0, Offset(0.62, 0.1),
      '080-0000-1006'),
  Centre('c7', 'GramaOne', L('GramaOne – Anekal', 'ಗ್ರಾಮ ಒನ್ – ಆನೇಕಲ್'),
      L('Taluk Office Road, Anekal', 'ತಾಲೂಕು ಕಚೇರಿ ರಸ್ತೆ, ಆನೇಕಲ್'),
      citizenDistrict, 16.3, '9:00 AM – 5:30 PM', 2, Offset(0.66, 0.9), '080-0000-1007'),
];

const districts = <L>[
  L('Bengaluru Urban', 'ಬೆಂಗಳೂರು ನಗರ'),
  L('Mysuru', 'ಮೈಸೂರು'),
  L('Mangaluru', 'ಮಂಗಳೂರು'),
  L('Hubballi', 'ಹುಬ್ಬಳ್ಳಿ'),
  L('Belagavi', 'ಬೆಳಗಾವಿ'),
  L('Kalaburagi', 'ಕಲಬುರಗಿ'),
  L('Ballari', 'ಬಳ್ಳಾರಿ'),
];

const weatherByDistrict = <String, WeatherData>{
  'Bengaluru Urban': WeatherData(
      district: 'Bengaluru Urban', temp: 26, feels: 27, humidity: 68, wind: 12, rainChance: 40,
      aqi: 82, pm25: 34, pm10: 61, uv: 6, condition: 'cloudy',
      hourly: [24, 25, 26, 27, 27, 26, 25, 24],
      daily: [(28, 19, 'cloudy'), (27, 19, 'rain'), (26, 18, 'rain'), (27, 18, 'cloudy'),
        (28, 19, 'sunny'), (29, 19, 'sunny'), (28, 20, 'cloudy')]),
  'Mysuru': WeatherData(
      district: 'Mysuru', temp: 28, feels: 29, humidity: 61, wind: 9, rainChance: 25,
      aqi: 54, pm25: 19, pm10: 44, uv: 7, condition: 'sunny',
      hourly: [25, 27, 28, 29, 29, 28, 26, 25],
      daily: [(30, 19, 'sunny'), (30, 20, 'cloudy'), (28, 19, 'rain'), (28, 19, 'cloudy'),
        (29, 19, 'sunny'), (30, 20, 'sunny'), (30, 20, 'sunny')]),
  'Mangaluru': WeatherData(
      district: 'Mangaluru', temp: 30, feels: 35, humidity: 79, wind: 15, rainChance: 70,
      aqi: 47, pm25: 16, pm10: 38, uv: 8, condition: 'rain',
      hourly: [28, 29, 30, 30, 29, 28, 28, 27],
      daily: [(31, 24, 'rain'), (30, 24, 'storm'), (30, 24, 'rain'), (31, 25, 'rain'),
        (31, 25, 'cloudy'), (32, 25, 'cloudy'), (32, 25, 'sunny')]),
  'Hubballi': WeatherData(
      district: 'Hubballi', temp: 29, feels: 30, humidity: 52, wind: 14, rainChance: 15,
      aqi: 96, pm25: 41, pm10: 88, uv: 8, condition: 'sunny',
      hourly: [26, 28, 29, 30, 30, 29, 27, 26],
      daily: [(31, 20, 'sunny'), (31, 20, 'sunny'), (30, 20, 'cloudy'), (30, 19, 'cloudy'),
        (31, 20, 'sunny'), (32, 20, 'sunny'), (32, 21, 'sunny')]),
  'Belagavi': WeatherData(
      district: 'Belagavi', temp: 27, feels: 28, humidity: 57, wind: 11, rainChance: 20,
      aqi: 68, pm25: 26, pm10: 57, uv: 7, condition: 'cloudy',
      hourly: [24, 26, 27, 28, 28, 27, 25, 24],
      daily: [(29, 18, 'cloudy'), (29, 18, 'sunny'), (28, 18, 'cloudy'), (28, 18, 'rain'),
        (29, 18, 'sunny'), (30, 19, 'sunny'), (30, 19, 'sunny')]),
  'Kalaburagi': WeatherData(
      district: 'Kalaburagi', temp: 33, feels: 35, humidity: 38, wind: 16, rainChance: 5,
      aqi: 134, pm25: 62, pm10: 118, uv: 9, condition: 'sunny',
      hourly: [29, 31, 33, 34, 34, 33, 31, 29],
      daily: [(35, 22, 'sunny'), (35, 22, 'sunny'), (34, 22, 'sunny'), (34, 21, 'cloudy'),
        (35, 22, 'sunny'), (35, 23, 'sunny'), (36, 23, 'sunny')]),
  'Ballari': WeatherData(
      district: 'Ballari', temp: 34, feels: 36, humidity: 36, wind: 13, rainChance: 5,
      aqi: 162, pm25: 77, pm10: 141, uv: 9, condition: 'sunny',
      hourly: [30, 32, 34, 35, 35, 34, 32, 30],
      daily: [(36, 23, 'sunny'), (36, 23, 'sunny'), (35, 23, 'sunny'), (35, 22, 'cloudy'),
        (36, 23, 'sunny'), (36, 23, 'sunny'), (37, 24, 'sunny')]),
};

const faqs = <(L, L)>[
  (
    L('How long does an Income Certificate take?', 'ಆದಾಯ ಪ್ರಮಾಣಪತ್ರಕ್ಕೆ ಎಷ್ಟು ಸಮಯ ಬೇಕು?'),
    L('Up to 21 working days under the Sakala guarantee. You can follow every step in Track.',
        'ಸಕಾಲ ಖಾತರಿಯಡಿ 21 ಕೆಲಸದ ದಿನಗಳವರೆಗೆ. ಟ್ರ್ಯಾಕ್‌ನಲ್ಲಿ ಪ್ರತಿ ಹಂತವನ್ನು ನೋಡಬಹುದು.')
  ),
  (
    L('Do I have to upload documents again?', 'ದಾಖಲೆಗಳನ್ನು ಮತ್ತೆ ಅಪ್‌ಲೋಡ್ ಮಾಡಬೇಕೇ?'),
    L('No. Once DigiLocker is linked, SevaOne reuses your documents across services.',
        'ಇಲ್ಲ. ಡಿಜಿಲಾಕರ್ ಲಿಂಕ್ ಮಾಡಿದ ನಂತರ, ಸೇವಾಒನ್ ನಿಮ್ಮ ದಾಖಲೆಗಳನ್ನು ಎಲ್ಲಾ ಸೇವೆಗಳಲ್ಲಿ ಮರುಬಳಕೆ ಮಾಡುತ್ತದೆ.')
  ),
  (
    L('What if my application is delayed?', 'ನನ್ನ ಅರ್ಜಿ ತಡವಾದರೆ ಏನು ಮಾಡಬೇಕು?'),
    L('File a grievance from Help. It is routed to iPGRS and you can track it there.',
        'ಸಹಾಯ ವಿಭಾಗದಿಂದ ಕುಂದುಕೊರತೆ ಸಲ್ಲಿಸಿ. ಅದು ಐಪಿಜಿಆರ್‌ಎಸ್‌ಗೆ ಹೋಗುತ್ತದೆ ಮತ್ತು ಅಲ್ಲಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಬಹುದು.')
  ),
  (
    L('I do not have a smartphone with me. What can I do?', 'ನನ್ನ ಬಳಿ ಸ್ಮಾರ್ಟ್‌ಫೋನ್ ಇಲ್ಲ. ಏನು ಮಾಡಬಹುದು?'),
    L('Use SMS from any phone, call 1902, or visit a GramaOne or Karnataka One centre.',
        'ಯಾವುದೇ ಫೋನ್‌ನಿಂದ ಎಸ್‌ಎಂಎಸ್ ಬಳಸಿ, 1902ಗೆ ಕರೆ ಮಾಡಿ, ಅಥವಾ ಗ್ರಾಮ ಒನ್ / ಕರ್ನಾಟಕ ಒನ್ ಕೇಂದ್ರಕ್ಕೆ ಭೇಟಿ ನೀಡಿ.')
  ),
];

class Job {
  final L title, dept, place, pay, qualification;
  final int openings, daysLeft;
  final String field; // admin | engineering | health | transport | education
  const Job(this.title, this.dept, this.place, this.pay, this.qualification, this.openings,
      this.daysLeft, this.field);
}

const jobs = <Job>[
  Job(L('Village Accountant', 'ಗ್ರಾಮ ಲೆಕ್ಕಿಗ'), L('Revenue Department', 'ಕಂದಾಯ ಇಲಾಖೆ'),
      L('Across Karnataka', 'ಕರ್ನಾಟಕದಾದ್ಯಂತ'), L('₹21,400 – ₹42,000', '₹21,400 – ₹42,000'),
      L('PUC pass', 'ಪಿಯುಸಿ ಉತ್ತೀರ್ಣ'), 1000, 42, 'admin'),
  Job(L('Junior Engineer (Electrical)', 'ಕಿರಿಯ ಇಂಜಿನಿಯರ್ (ವಿದ್ಯುತ್)'), L('BESCOM', 'ಬೆಸ್ಕಾಂ'),
      L('Bengaluru', 'ಬೆಂಗಳೂರು'), L('₹33,450 – ₹62,600', '₹33,450 – ₹62,600'),
      L('Diploma in Electrical', 'ಎಲೆಕ್ಟ್ರಿಕಲ್ ಡಿಪ್ಲೊಮಾ'), 120, 18, 'engineering'),
  Job(L('Staff Nurse', 'ಸ್ಟಾಫ್ ನರ್ಸ್'), L('Health and Family Welfare', 'ಆರೋಗ್ಯ ಮತ್ತು ಕುಟುಂಬ ಕಲ್ಯಾಣ'),
      L('District hospitals', 'ಜಿಲ್ಲಾ ಆಸ್ಪತ್ರೆಗಳು'), L('₹30,350 – ₹58,250', '₹30,350 – ₹58,250'),
      L('B.Sc Nursing', 'ಬಿ.ಎಸ್ಸಿ ನರ್ಸಿಂಗ್'), 340, 9, 'health'),
  Job(L('Bus Conductor', 'ಬಸ್ ನಿರ್ವಾಹಕ'), L('BMTC', 'ಬಿಎಂಟಿಸಿ'), L('Bengaluru', 'ಬೆಂಗಳೂರು'),
      L('₹18,660 – ₹25,300', '₹18,660 – ₹25,300'), L('PUC pass', 'ಪಿಯುಸಿ ಉತ್ತೀರ್ಣ'), 2500, 27,
      'transport'),
  Job(L('Primary School Teacher', 'ಪ್ರಾಥಮಿಕ ಶಾಲಾ ಶಿಕ್ಷಕ'), L('School Education', 'ಶಾಲಾ ಶಿಕ್ಷಣ'),
      L('Across Karnataka', 'ಕರ್ನಾಟಕದಾದ್ಯಂತ'), L('₹25,800 – ₹51,400', '₹25,800 – ₹51,400'),
      L('D.El.Ed and TET', 'ಡಿ.ಇಡಿ ಮತ್ತು ಟಿಇಟಿ'), 1500, 33, 'education'),
  Job(L('First Division Assistant', 'ಪ್ರಥಮ ದರ್ಜೆ ಸಹಾಯಕ'), L('Karnataka Public Service Commission', 'ಕರ್ನಾಟಕ ಲೋಕಸೇವಾ ಆಯೋಗ'),
      L('Various departments', 'ವಿವಿಧ ಇಲಾಖೆಗಳು'), L('₹37,900 – ₹70,850', '₹37,900 – ₹70,850'),
      L('Any degree', 'ಯಾವುದೇ ಪದವಿ'), 410, 21, 'admin'),
];
