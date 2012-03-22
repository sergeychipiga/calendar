module EventsHelper

  def events_in_day(date)
    date = Date.parse(date)
    events = current_user.events.select('id, title').where('point_date = ?', date)
    events += current_user.events.select('id, title').where('point_date < date(?) AND cycle = "daily"', date)
    events += current_user.events.select('id, title').where('point_date < date(?) AND cycle = "weekly" AND dow = strftime("%w", ?)', date, date)
    events += current_user.events.select('id, title').where('point_date < date(?) AND cycle = "monthly" AND strftime("%d", point_date) = strftime("%d", ?)', date, date)
    events += current_user.events.select('id, title').where('point_date < date(?) AND cycle = "yearly" AND point_date LIKE "%-" || strftime("%m", ?) || "-" || strftime("%d", ?)', date, date, date)
    return events
  end

  def events_in_month(month, year)
    list_once = {}
    events = current_user.events.select('point_date').where('point_date < date(?) AND point_date > date(?) AND cycle IS NULL', Date.civil(year.to_i, month.to_i, -1), year + '-' + month + '-01')
    events.each {|e|
      if list_once[e['point_date'].day].nil?
        list_once[e['point_date'].day] = 1
      else
        list_once[e['point_date'].day] += 1
      end
    }
    list_period = {}
    1.upto(Date.civil(year.to_i, month.to_i, -1).day) {|i|
      list_period[i] = 0
    }
    events = current_user.events.select('point_date, cycle, dow').where('point_date < date(?) AND cycle IS NOT NULL', Date.civil(year.to_i, month.to_i, -1))
    events.each {|e|
      case e['cycle']
      when 'daily'
        list_period.each {|key, value|
          list_period[key] += 1
        }
      when 'weekly'
        list_period.each {|key, value|
          if Date.civil(year.to_i, month.to_i, key).wday == e['dow']
            if Date.civil(year.to_i, month.to_i, key).day >= e['point_date'].day
              list_period[key] += 1
            end
          end
        }
      when 'monthly'
        list_period[e['point_date'].day] += 1
      when 'yearly'
        if e['point_date'].month == month.to_i
          list_period[e['point_date'].day] +=1
        end
      end
    }
    events = []
    i = 0
    list_period.each {|key, value|
      if !list_once[key].nil?
        value += list_once[key]
      end
      if value != 0
        events[i] = {}
        events[i]['day'] = key
        events[i]['count'] = value
        i += 1
      end
    }
    return events
  end
end