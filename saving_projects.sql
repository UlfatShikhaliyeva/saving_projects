alter session set "_oracle_script"=true;


create user ulfat_sh identified by ulfat1;--userin yaradilmasi 

grant create session to ulfat_sh; 
grant create table to ulfat_sh;
grant create tablespace to ulfat_sh;
grant create  procedure to ulfat_sh;
grant create  trigger to ulfat_sh; 
grant create  job to ulfat_sh;
grant ALL PRIVILEGES to ulfat_sh;


--Saving Projects 

--Creating tables 

Create table customers_s (customer_no number primary key,
                         customer_type varchar2(1),
                         full_name varchar2(100),
                         address varchar2(100),
                         country varchar2(100));
                         
alter table customers_s modify customer_type varchar2(1)      

select * from customers_s
                   
create table branches (branch_id number primary key,
                      branch_name varchar2(100));
                      
                      
create table currency (curr_id VARCHAR2(3),
                      curr_code NUMBER PRIMARY KEY);                       
 

create table  productss ( product_id NUMBER PRIMARY KEY,
                        product_name VARCHAR2(200),
                        min_amount NUMBER,
                        max_amount NUMBER,
                        min_term NUMBER,
                        max_term NUMBER,
                        curr_code NUMBER REFERENCES currency (curr_code) ,
                        interest_rate NUMBER); 
                                                

create table  deposits (deposit_id NUMBER PRIMARY KEY,
                       cif NUMBER REFERENCES customers_s(CUSTOMER_NO),
                       product_id NUMBER REFERENCES productss(product_id) ,
                       contract_date DATE,
                       deadline DATE, 
                       amount NUMBER,
                       curr_code NUMBER REFERENCES currency (curr_code),
                       BRANCH_ID NUMBER  REFERENCES branches(BRANCH_ID));   
                       
--Creating Index 

CREATE INDEX dep_date ON deposits(contract_date);
CREATE INDEX dep_deadli ON deposits(deadline);     

/*1.Ümumi bir package yaradın. 
Bu package-də qeyd edilən cədvəllərin hər birinə insert edən prosedurlar yazın və 
insertlərinizi bu prosedurlar vasitəsilə icra edin.*/

create or replace package my_data_insert is
  procedure insert_customers(p_customer_no   number,
                             p_customer_type varchar2,
                             p_full_name     varchar2,
                             p_address       varchar2,
                             p_country       varchar2);

  procedure insert_branch(p_branch_id number, p_branch_name varchar2);
  
  procedure insert_currency(p_curr_id varchar2, p_curr_code number);
  
  procedure insert_product(p_product_id    number,
                           p_product_name  varchar2,
                           p_min_amount    number,
                           p_max_amount    number,
                           p_min_term      number,
                           p_max_term      number,
                           p_curr_code     number,
                           p_interest_rate number);

procedure insert_deposit(p_deposit_id    number,
                         p_cif           number,
                         p_product_id    number,
                         p_contract_date date,
                         p_deadline      date,
                         p_amount        number,
                         p_curr_code     number,
                         p_BRANCH_ID     number);
end;

--Package Body 

create or replace package body my_data_insert is 
procedure insert_customers(p_customer_no   number,
                             p_customer_type varchar2,
                             p_full_name     varchar2,
                             p_address       varchar2,
                             p_country       varchar2)
                              
as 
begin
  insert into customers_s
    (customer_no, customer_type, full_name, address, country)
  values
    (p_customer_no,p_customer_type, p_full_name, p_address, p_country);

  commit;
end;
    
procedure insert_branch(p_branch_id number, p_branch_name varchar2) as
begin
  insert into branches
    (branch_id, branch_name)
  values
    (p_branch_id, p_branch_name);
  commit;
end;

procedure insert_currency(p_curr_id varchar2, p_curr_code number) as
begin
  insert into currency
    (curr_id, curr_code)
  values
    (p_curr_id, p_curr_code);
  commit;
end;
  
  
procedure insert_product( p_product_id    number,
                           p_product_name  varchar2,
                           p_min_amount    number,
                           p_max_amount    number,
                           p_min_term      number,
                           p_max_term      number,
                           p_curr_code     number,
                           p_interest_rate number)
as begin 
insert into productss
  (product_id,
   product_name,
   min_amount,
   max_amount,
   min_term,
   max_term,
   curr_code,
   interest_rate)
values
  (p_product_id,
   p_product_name,
   p_min_amount,
   p_max_amount,
   p_min_term,
   p_max_term,
   p_curr_code,
   p_interest_rate);
commit;
end;

procedure insert_deposit(p_deposit_id    number,
                         p_cif           number,
                         p_product_id    number,
                         p_contract_date date,
                         p_deadline      date,
                         p_amount        number,
                         p_curr_code     number,
                         p_branch_ID     number)

as begin 
insert into deposits
  (deposit_id,
   cif,
   product_id,
   contract_date,
   deadline,
   amount,
   curr_code,
   branch_id)

values
  (p_deposit_id,
   p_cif,
   p_product_id,
   p_contract_date,
   p_deadline,
   p_amount,
   p_curr_code,
   p_branch_ID);
commit;
end;
end;

--Package inserts 

begin
  my_data_insert.insert_customers(p_customer_no   => 4949302,
                                  p_customer_type => 'M',
                                  p_full_name     => 'Guliyev Orkhan',
                                  p_address       => 'Baku Surakhani district',
                                  p_country       => NULL);
                                  

  my_data_insert.insert_branch(p_branch_id   => 4,
                               p_branch_name => 'Sabuchu Branches');
  my_data_insert.insert_currency(p_curr_id => 'EUR', p_curr_code => 756);
end;
  
begin
  my_data_insert.insert_product(p_product_id    => 205,
                                p_product_name  => 'Depozit',
                                p_min_amount    => 1200,
                                p_max_amount    => 1800,
                                p_min_term      => 13,
                                p_max_term      => 36,
                                p_curr_code     => 756,
                                p_interest_rate => 6);
end; 
                               
begin
  my_data_insert.insert_deposit(p_deposit_id    => 105,
                                p_cif           => 4949302,
                                p_product_id    => 205,
                                p_contract_date => to_date('23.01.2020',
                                                           'dd.mm.yyyy'),
                                p_deadline      => to_date('23.01.2013',
                                                           'dd.mm.yyyy'),
                                p_amount        => 1300,
                                p_curr_code     => 756,
                                p_BRANCH_ID     => 4);
                                
end;


select * from customers_s for update;
select * from branches for update;
select * from  currency for update;
select * from productss for update;
select * from deposits for update;


/*2.  Müştərinin qoyduğu məbləğə və term-ə əsasən ona faiz təyin edən və
 bu faizi ekrana çıxaran prosedur qurun. Həmin faizləri yaratdığınız məhsul cədvəlinə əsasən təyin edin. 
Yəni məhsul cədvəlində müddət valuta və məbləğ aralığına görə faizlər saxlanılsın.*/

create or replace type InterestList as table of number;


create or replace function get_calculate_interest(p_amount   number,
                                                  p_term     number,
                                                  p_currency varchar2)

 return InterestList as
  v_interests InterestList := InterestList();
begin
  select p.interest_rate
    bulk collect
    into v_interests
    from productss p
   where p.curr_code =
         (select c.curr_code from currency c where c.curr_id = p_currency)
     and p_amount between p.min_amount and p.max_amount
     and p_term between p.min_term and p.max_term;

  return v_interests;
end;

declare
  v_interests InterestList;
begin
  v_interests := get_calculate_interest(p_amount   => 1800,
                                        p_term     => 24,
                                        p_currency => 'GBP');
  for i in 1 .. v_interests.count loop
    dbms_output.put_line('Interest ' || i || ': ' || v_interests(i));
  end loop;
end;


select * from productss;
select * from currency;



                                      
/*3. 2 eyniadlı prosedur yaradın  OVERLOADING-dən istifade edin.Prosedurlardan birinə əgər müqavilə 
id-si ötürülürsə onda ekrana müştərinin sonda alacağı faiz məbləği ekrana çıxsın. 
Digər prosedurda isə parameter ötürülməsin və avtomatik olaraq cari gün üzrə müqavilə 
açan müştərilərin alacağı faiz məbləği cədvəldə saxlanılsın.*/

create or replace package interest_amount is
  procedure interest_amount(deposit_no in number, int_amount out number); -- in daxil etdiyimiz deyerdir, out prosedurun hesablayib verdiyi neticedir.
  procedure interest_amount;
end;

create or replace package body interest_amount is
  procedure interest_amount(deposit_no in number, int_amount out number)
  
   is
  begin
    select trunc((d.amount / 100) *
                 ((select p.interest_rate
                     from productss p
                    where p.product_id = d.product_id)) / 12 *
                 months_between(d.deadline, d.contract_date))
      into int_amount
      from deposits d
     where deposit_no = d.deposit_id;
    dbms_output.put_line('Interest amount: ' || int_amount);
  end;
  procedure interest_amount is
  begin
    update deposits dp
       set dp.interest_amount =
           (select (dp.amount / 100) * (p.interest_rate / 12) *
                   months_between(dp.deadline, dp.contract_date)
              from productss p
             where p.product_id = dp.product_id)
     where dp.contract_date = trunc(sysdate);
  
    dbms_output.put_line('Interest amounts have been updated.');
  end;
end;

declare
  result_ number;
begin
  interest_amount.interest_amount(deposit_no =>106, int_amount => result_);
end;

begin
  interest_amount.interest_amount;
end;

ALTER TABLE deposits ADD interest_amount NUMBER;
select * from productss;
select * from  deposits for update;

select months_between(d.deadline, d.contract_date) from deposits d where d.deposit_id=107;


/*4.Bir funksiya yaradın və funksiya ekrana müştəri gəlib pulunu götürmək istədikdə ona nə qədər pul ödənəcək onu hesablasın. 
Əgər müştəri müqavilənin vaxtı bitdikdən sonra gəlibsə o zaman öz pulunu və alacağı bütün faiz məbləği ekrana çıxmalıdır. 
Əgər vaxtı bitməmiş gəlibsə o zaman öz pulunu və faizlə alacağı məbləğin 1 faizi ekrana çıxmalıdır. 
Bazada funksiyaya ötürülən argumentə uyğun data yoxdursa ekrana error qaytarın və həmin datanı exception_data cədvəlinə insert edin.*/


--exception melumatlari ucun cedvel 

create table exception_data (err_id number,
                            err_msg varchar(400));

--mushteri gelib pulu goturmesi ucun cedvel 

select * from exception_data;

drop table exception_data;
                                                   
--create function

CREATE OR REPLACE FUNCTION calculate_payment(v_dep_id              NUMBER, --id 
                                             v_date_of_take_amount DATE --vaxti bitdikden sonra gelib gelmediyini yoxlayir
                                             ) RETURN NUMBER IS
  v_payment_amount NUMBER;
  v_deadline       DATE;
  except_code      VARCHAR2(200);
  except_msg       VARCHAR2(2000);
BEGIN
  -- -- Depozitin bitmə tarixini əldə etmək
  SELECT d.deadline
    INTO v_deadline
    FROM deposits d
   WHERE d.deposit_id = v_dep_id;

  -- Əgər verilən tarix bitmə tarixindən sonra olduğu təqdirdə
  IF v_date_of_take_amount > v_deadline THEN
    -- Ödəniş məbləğini hesablayaq
    SELECT (d.amount / 100) *
           ((SELECT p.interest_rate
               FROM productss p
              WHERE p.product_id = d.product_id)) / 12 *
           MONTHS_between(d.deadline, d.contract_date) + d.amount
      INTO v_payment_amount
      FROM deposits d
     WHERE d.deposit_id = v_dep_id;
  
    DBMS_OUTPUT.PUT_LINE('Customer should receive: ' || v_payment_amount);
  ELSE
    -- Ödəniş məbləğini hesablayaq
    SELECT ((d.amount / 100) *
           ((SELECT p.interest_rate
                FROM productss p
               WHERE p.product_id = d.product_id)) / 12 *
           MONTHS_between(d.deadline, d.contract_date)) / 100 * 1 +
           d.amount
      INTO v_payment_amount
      FROM deposits d
     WHERE d.deposit_id = v_dep_id;
  
    DBMS_OUTPUT.PUT_LINE('Customer should receive: ' || v_payment_amount);
  END IF
  -- Hesablanan ödəniş məbləğini qaytarırıq
  RETURN v_payment_amount;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- NO_DATA_FOUND xətası baş verərsə
    DBMS_OUTPUT.PUT_LINE('Error.1');
    except_code := SQLCODE;
    except_msg  := SQLERRM;
    -- Xətaları loglamaq üçün məlumatları əlavə edirik
    INSERT INTO exception_data
      (err_id, err_msg)
    VALUES
      (except_code, except_msg);
    COMMIT;
END;

SELECT calculate_payment(v_dep_id              => 106,
                         v_date_of_take_amount => to_date('01.05.2024',
                                                          'dd.mm.yyyy'))
  FROM dual;

BEGIN
  dbms_output.put_line(calculate_payment(v_dep_id              => 106,
                                         v_date_of_take_amount => to_date('19.05.2024',
                                                                          'dd.mm.yyyy')));
END;





select * from exception_data;
select * from deposits;
select * from productss;

/* 5.Depozitlərin prolongasiyasını yəni uzadılmasını təyin edən prosedur qurun və bu proseduru job vasitəsilə hər gün axşam saat 10-da işə salın. 
Prolongasiya prosesinin işləmə məntiqi belədir-Müştəri əgər müqavilənin bitmə günündə müştəri gəlib məbləği götürmürsə 
o zaman müştərinin əsas məbləği alacağı faizlə cəmlənərək və müqavilənin başlama və bitmə vaxtı  update edilsin.
Məsələn-1000 azn məbləğ qoymuşdur müştəri və bu müqavilənin başlama vaxtı 24.01.2023-dür və bitmə vaxtı 24.06.2023-dür. Və müqavilənin faizi 5 faizdir. 
Müştəri 25.06.2023 tarixində məbləği götürmürsə o zaman depozit prolongasiya olacaq yəni başlama tarixi 24.06.2023 və bitmə vaxtı 24.01.2024 olacaq.
Məbləğ isə 1000 deyil də 1000+1000*5/100=1050 olacaq.*/
select * from deposits for update;

CREATE OR REPLACE PROCEDURE prolong_deposit(dep_no NUMBER) IS
  p_deadline DATE;
BEGIN
  -- deposit_id ilə bitmə tarixini əldə etmək
  SELECT d. deadline
    INTO p_deadline
    FROM deposits d
   WHERE d.deposit_id = dep_no;
  -- Əgər bitmə tarixi bir gün sonradırsa
  IF trunc(SYSDATE) = p_deadline + 1 THEN
    UPDATE deposits a
       SET a.amount        = a.amount +
                             (a.amount *
                             (SELECT p.interest_rate
                                 FROM productss p
                                WHERE p.product_id = a.product_id) / 100),
           a.deadline      = ADD_MONTHS(a.deadline,
                                        MONTHS_between(a.deadline,
                                                       a.contract_date)),
           a.contract_date = a.deadline
     WHERE a.deposit_id = dep_no;
  
    DBMS_OUTPUT.PUT_LINE('Prolongation occurred.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Prolongation did not occur!');
  END IF;
END;

BEGIN
prolong_deposit(dep_no => 106);
END;
  
 
  
  select *from deposits; for update;
  
-- Creating job

BEGIN
  -- 'update_data' adlı bir job yaratmaq
  dbms_scheduler.create_job(job_name        => 'update_data', --Job adi
                            job_type        => 'plsql_block', --Jobun novu 
                            job_action      => 'BEGIN prolong_deposit (106); end; ', --Jobu ishe salacaq PL/SQL bloku
                            repeat_interval => 'freq=daily; BYHOUR=22', --Ishe salma vaxti saat 22:00da
                            enabled         => TRUE, --Job aktivdir 
                            auto_drop       => FALSE); --Jobun avtomatik silinmesi yoxdur. 
END;


/*Cədvəldə update olan zaman trigger işə düşsün və köhnə məlumatları arxiv cədvəlində loglasın.*/
-- creating trigger

CREATE TABLE archive_log(user_name VARCHAR2(200),
                           change_date DATE,
                           old_amount NUMBER,
                           new_amount NUMBER,
                           old_deadline DATE,
                           new_deadline DATE,
                           old_contract_date DATE,
                           new_contract_date DATE);
                           
select * from archive_log;

CREATE OR REPLACE TRIGGER archiving
BEFORE UPDATE OR DELETE
ON deposits FOR EACH ROW
BEGIN
  INSERT INTO archive_log VALUES(USER,SYSDATE,:old.amount,:new.amount,:OLD.deadline,
  :NEW.deadline,:OLD.contract_date,:NEW.contract_date);
END;  
  
  
  

                                                    
                            
                            





