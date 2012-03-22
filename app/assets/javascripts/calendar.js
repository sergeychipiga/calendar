function setUp(){
  document.getElementById('calendar').innerHTML = months() + years() +
                                                  '<div id="cal"></div>';
  document.getElementById('month').selectedIndex = new Date().getMonth();
  var yearList = document.getElementById('year');
  curYear = new Date().getYear() + 1900;
  i = 0;
  while (year = yearList.options[i]){
    if (curYear == year.value){
      yearList.selectedIndex = i
      break;
    }
    i++;
  }
  calendar();
}

function years(){
  years = '<select id="year">';
  for (i = 0; i <= 200; i++){
    years += '<option>' + (1900 + i) + '</option>';
  }
  years += '</select>';
  return years;
}

function months(){
  months = '<select id="month">' +
            '<option>Январь</option>' +
            '<option>Февраль</option>' +
            '<option>Март</option>' +
            '<option>Апрель</option>' +
            '<option>Май</option>' +
            '<option>Июнь</option>' +
            '<option>Июль</option>' +
            '<option>Август</option>' +
            '<option>Сентябрь</option>' +
            '<option>Октябрь</option>' +
            '<option>Ноябрь</option>' +
            '<option>Декабрь</option>' +
            '</select>';
  return months;
}

function calendar(){
  var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  year = document.getElementById('year').value;
  if (year % 4 == 0) daysInMonth[1] = 29;
  month = document.getElementById('month').selectedIndex;
  var days = daysInMonth[month];
  var firstDay = new Date(year, month, 1).getDay();
  if (firstDay == 0) firstDay = 7;
  var cur_year = new Date().getYear();
  var cur_month = new Date().getMonth();
  var cur_day = new Date().getDate();
  var dayValue = 1;
  var day = '';
  var cls = '';
  var calendar = '<table><tr><th>Mon</th><th>Tue</th><th>Wed</th>' +
                  '<th>Thu</th><th>Fri</th><th>Sat</th><th>Sun</th></tr>';
  for (j = 0; j < 6; j++){
    calendar += '<tr>';
    for (i = 1; i < 8; i++){
      if (i >= firstDay || j > 0){ 
        if (dayValue <= days){
          day = dayValue++;
          cls = 'active_cell';
        }else{
          day = '';
          cls = 'inactive_cell';
        }
      }else{
        cls = 'inactive_cell';
      }
      if (cur_day == day && (1900 + cur_year) == year && cur_month == month){
        cls += ' today';
      }
      calendar +='<td class="' + cls + '">' + day + '</td>';
    }
    calendar += '</tr>';
  }
  calendar += '</table>';
  document.getElementById('cal').innerHTML = calendar;
}