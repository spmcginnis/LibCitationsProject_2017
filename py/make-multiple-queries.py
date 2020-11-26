from subprocess import run
import xml.etree.ElementTree as ET
import string
    # for the .replace method

"""
File to call multiple queries using queryfile = *.xq
"""

#root = ET.parse('..\\ProjectFiles\\xml\\dept-index.xml').getroot()
#
#list = root.findall('dept')

saxon = '..\\ProjectFiles\\saxon\\bin\\Query.exe'
queryfile = "makeCSVreport-by-dept.xq"
out_name_stem = '-report-20170522.csv'

# The list of departments for which we haven't yet created reports.
list = ['Agricultural and Environmental Chemistry',\
'Business Administration', 'Comparative Biochemistry',\
'Demography', 'Educational Leadership',\
'Environmental Health Sciences', 'Epidemiology',\
'Health Policy', 'Industrial Engineering and Operations Research',\
'Infectious Diseases and Immunity',\
'Information Management and Systems', 'Integrative Biology',\
'Interdisciplinary', 'Jurisprudence and Social Policy', 'Law',\
'Logic and the Methodology of Science', 'Materials Science and Engineering',\
'Materials Science and Mineral Engineering','Mathematics', 'Mechanical Engineering',\
'Metabolic Biology','Microbiology','Molecular & Biochemical Nutrition','Molecular Toxicology',\
'Molecular and Cell Biology','Neuroscience','Nuclear Engineering','Philosophy',\
'Physics','Plant Biology','Psychology','Public Policy','Science and Mathematics Education',\
'Social Welfare','Sociology and Demography','Special Education','Statistics','Vision Science',\
'Wildland Resource Science']

# for dept in list:
for dept in list:
    dept_name = dept.replace(' ', '-')
    dept_name = dept_name.lower()
    print(dept_name)
    print(len(dept_name))
    command = saxon + ' -q:..\\ProjectFiles\\xq-xslt\\' + queryfile + " -o:..\\output\\" + dept_name + out_name_stem + ' dept="'+dept+'"'
    print(command)
    run(command)
