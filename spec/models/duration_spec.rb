require 'spec_helper'
describe Duration do
  describe "#dates" do
    subject { @duration.to_s }
   
    context "date objects"  do
      it "start_at only" do
        add_date(start_at: parse("2002-01-01"))
        should eq "01.01.2002"
      end

      it "finish_at only" do
        add_date(finish_at: parse("2002-01-01"))
        should eq "01.01.2002"
      end

      it "start and finish" do
        add_date(start_at: parse("2002-01-01"),finish_at: parse("2002-01-13"))
        should eq "01.01.2002 - 13.01.2002"
      end

      it "start and finish on same day" do
        add_date(start_at: parse("2002-01-01"),finish_at: parse("2002-01-01"))
        should eq "01.01.2002"
      end
      
      it "works with regular dates as well" do
        @duration = Duration.new(Date.new(2010, 10, 9), Date.new(2010, 10, 12))
        should eq "09.10.2010 - 12.10.2010"
      end
    end

    context "time objects" do
      it "start_at only" do
        add_date(start_at: parse("2002-01-01 13:30"))
        should eq "01.01.2002 13:30"
      end
      it "finish_at only" do
        add_date(finish_at: parse("2002-01-01 13:30"))
        should eq  "01.01.2002 13:30"
      end

      it "start and finish" do
        add_date(start_at: parse("2002-01-01 13:30"),finish_at: parse("2002-01-13 15:30"))
        should eq "01.01.2002 13:30 - 13.01.2002 15:30"
      end

      it "start and finish on same day, start time" do
        add_date(start_at: parse("2002-01-01"),finish_at: parse("2002-01-01 13:30"))
        should eq "01.01.2002 00:00 - 13:30"
      end

      it "start and finish on same day, finish time" do
        add_date(start_at: parse("2002-01-01 13:30"),finish_at: parse("2002-01-01 13:30"))
        should eq "01.01.2002 13:30"
      end

      it "start and finish on same day, both times" do
        add_date(start_at: parse("2002-01-01 13:30"),finish_at: parse("2002-01-01 15:30"))
        should eq "01.01.2002 13:30 - 15:30"
      end
    end
  end
  
  context "#active?" do
    subject { @duration }
    
    context "by date" do
      it "today is active" do
        @duration = Duration.new(Date.today, Date.today)
        should be_active
      end
      
      it "until today is active" do
        @duration = Duration.new(Date.today - 10.days, Date.today)
        should be_active
      end
      
      it "from today is active" do
        @duration = Duration.new(Date.today, Date.today + 10.days)
        should be_active
      end
      
      it "from tomorrow is not active" do
        @duration = Duration.new(Date.today + 1.day, Date.today + 10.days)
        should_not be_active
      end
      
      it "until yesterday is not active" do
        @duration = Duration.new(Date.today - 10.days, Date.today - 1.day)
        should_not be_active
      end
    end
    
    context "by Time" do
      it "now is active" do
        @duration = Duration.new(Time.zone.now - 1.minute, Time.zone.now + 1.minute)
        should be_active
      end
      
      it "until now is active" do
        @duration = Duration.new(Time.zone.now - 10.minute, Time.zone.now + 1.minute)
        should be_active
      end
      
      it "from now is active" do
        @duration = Duration.new(Time.zone.now - 1.minute, Time.zone.now + 10.minute)
        should be_active
      end
      
      it "from in a minute is not active" do
        @duration = Duration.new(Time.zone.now + 1.minute, Time.zone.now + 10.minute)
        should_not be_active
      end
      
      it "until a minute is not active" do
        @duration = Duration.new(Time.zone.now - 10.minute, Time.zone.now - 1.minute)
        should_not be_active
      end
    end
  end
  
  def parse(str)
    Time.zone.parse(str)
  end
  def add_date(date)
    @duration = Duration.new(date[:start_at], date[:finish_at])
  end

end

