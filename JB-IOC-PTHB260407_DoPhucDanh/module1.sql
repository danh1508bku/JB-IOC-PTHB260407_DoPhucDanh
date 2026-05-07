-------PHẦN 1: THAO TÁC VỚI DỮ LIỆU CÁC BẢNG-------

---1.Tạo bảng---
create table Passengers(
    passenger_id varchar(5) primary key,
    passenger_full_name varchar(100) not null,
    passenger_email varchar(100) not null unique,
    passenger_phone varchar(15) not null unique,
    passenger_cccd varchar(20) not null unique
);

create table Trains(
    train_id varchar(5) primary key,
    train_name varchar(100) not null,
    train_type varchar(10) not null,
    total_seats int not null
);

create table tickets(
    ticket_id varchar(5) primary key,
    passenger_id varchar(5) not null references Passengers(passenger_id),
    train_id varchar(5) not null references Trains(train_id),
    departure_date date not null,
    seat_number varchar(10) not null,
    ticket_price decimal(10,2) not null
);

create table Transactions(
    transaction_id varchar(5) primary key,
    ticket_id varchar(5) not null references tickets(ticket_id),
    payment_method varchar(50) not null,
    transaction_date date not null,
    amount decimal(10,2) not null
);

---2.Chèn dữ liệu mẫu---
insert into Passengers(passenger_id, passenger_full_name, passenger_email, passenger_phone, passenger_cccd) values
('P001', 'Nguyen Van An', 'an.nguyen@example.com', '0912345678', '001234567890'),
('P002', 'Tran Thi Binh', 'binh.tran@example.com', '0923456789', '002345678901'),
('P003', 'Le Minh Chau', 'chau.le@example.com', '0934567890', '003456789012'),
('P004', 'Pham Quoc Dat', 'dat.pham@example.com', '0945678901', '004567890123'),
('P005', 'Vo Thanh Em', 'em.vo@example.com', '0956789012', '005678901234');

insert into Trains(train_id, train_name, train_type, total_seats) values
('T001', 'Tau Thong Nhat 1', 'SE', 500),
('T002', 'Tau Thong Nhat 2', 'TN', 450),
('T003', 'Tau Sai Gon - Hue', 'SE', 400),
('T004', 'Tau Ha Noi - Lao Cai', 'TN', 350),
('T005', 'Tau Da Nang Express', 'SE', 300);

insert into Tickets(ticket_id, passenger_id, train_id, departure_date, seat_number, ticket_price) values
('TK001', 'P001', 'T001', '2025-06-10', 'A01', 850000),
('TK002', 'P002', 'T002', '2025-06-11', 'B05', 650000),
('TK003', 'P003', 'T003', '2025-06-12', 'C10', 720000),
('TK004', 'P004', 'T004', '2025-06-13', 'D12', 500000),
('TK005', 'P005', 'T005', '2025-06-14', 'E05', 900000);

insert into Transactions(transaction_id, ticket_id, payment_method, transaction_date, amount) values
('TR001', 'TK001', 'Credit Card', '2025-06-01', 850000),
('TR002', 'TK002', 'Cash', '2025-06-02', 650000),
('TR003', 'TK003', 'Bank Transfer', '2025-06-03', 720000),
('TR004', 'TK004', 'E-Wallet', '2025-06-04', 500000),
('TR005', 'TK005', 'Credit Card', '2025-06-05', 900000);

---3.Cập nhật dữ liệu---
update Tickets
set ticket_price = ticket_price * 0.85
where departure_date < '2025-05-01';

---4.Xóa dữ liệu---
delete from Transactions
where payment_method = 'E-Wallet' and amount < 200000;


-------PHẦN 2: TRUY VẤN DỮ LIỆU-------

---5.Lấy thông tin hành khách gồm: mã HK, họ tên, email, SĐT sắp xếp theo họ tên giảm dần.---
select passenger_id, passenger_full_name, passenger_email, passenger_phone
from Passengers
order by passenger_full_name desc;

---6.Lấy danh sách đoàn tàu gồm: mã tàu, tên tàu, tổng số ghế, sắp xếp theo số ghế tăng dần.---
select train_id, train_name, total_seats
from Trains
order by total_seats;

---7.Lấy thông tin vé đã đặt gồm: Họ tên hành khách, Tên tàu, Ngày khởi hành, Số ghế.---
select p.passenger_full_name, t.train_name, tk.departure_date, tk.seat_number
from Tickets tk, Passengers p, Trains t
where tk.passenger_id = p.passenger_id and tk.train_id = t.train_id;

---8.Lấy danh sách hành khách và tổng tiền đã thanh toán: mã HK, họ tên,
---phương thức thanh toán, số tiền thanh toán, sắp xếp theo số tiền tăng dần.
select p.passenger_id, p.passenger_full_name, tr.payment_method, tr.amount
from Passengers p, Transactions tr, Tickets tk
where p.passenger_id = tk.passenger_id and tk.ticket_id = tr.ticket_id
order by tr.amount;

---9.Lấy thông tin hành khách từ vị trí thứ 3 đến thứ 5 trong bảng Passengers sắp xếp theo tên (Z-A).---
select * from Passengers
order by passenger_full_name desc
limit 3 offset 2;

---10.Liệt kê các hành khách đã đặt ít nhất 3 vé tàu.---
select p.passenger_id, p.passenger_full_name, count(tk.ticket_id) as total_tickets
from Passengers p, Tickets tk
where p.passenger_id = tk.passenger_id
group by p.passenger_id, p.passenger_full_name
having count(tk.ticket_id) >= 3;

---11.Liệt kê các đoàn tàu đã có hơn 10 lượt khách đặt vé.---
select t.train_id, t.train_name, count(tk.ticket_id) as total_bookings
from Trains t, Tickets tk
where t.train_id = tk.train_id
group by t.train_id, t.train_name
having count(tk.ticket_id) > 10;

---12.Lấy danh sách hành khách có tổng tiền giao dịch > 2.000.000 VNĐ, 
---gồm: mã HK, họ tên, mã tàu, tổng tiền.
select p.passenger_id, p.passenger_full_name, tk.train_id, sum(tr.amount) as total_spent
from Passengers p, Tickets tk, Transactions tr
where p.passenger_id = tk.passenger_id and tk.ticket_id = tr.ticket_id
group by p.passenger_id, p.passenger_full_name, tk.train_id
having sum(tr.amount) > 2000000;

---13.Lấy danh sách hành khách có tên chứa chữ "Hoàng" hoặc địa chỉ email thuộc miền "@gmail.com". 
---Sắp xếp theo tên tăng dần.
select * from Passengers
where passenger_full_name ilike '%Hoàng%' or passenger_email like '%@gmail.com'
order by passenger_full_name;

---14.Lấy danh sách đoàn tàu (trang thứ 2, mỗi trang 5 bản ghi) sắp xếp theo số ghế giảm dần.---
select * from Trains
order by total_seats desc
limit 5 offset 5;


-------PHẦN 3: TẠO VIEW-------

---15.Tạo view vw_UpcomingTrips hiển thị thông tin tàu và hành khách đã đặt vé 
---với ngày khởi hành sau ngày 2025-06-01, gồm: Họ tên, Tên tàu, Số ghế, Giá vé, Ngày khởi hành.
create view vw_UpcomingTrips as
select p.passenger_full_name, t.train_name, tk.seat_number, tk.ticket_price, tk.departure_date
from Passengers p, Trains t, Tickets tk
where p.passenger_id = tk.passenger_id and tk.train_id = t.train_id and tk.departure_date > '2025-06-01';

---16.Tạo view vw_HighValueTickets hiển thị khách hàng đặt vé có giá trị trên 500.000 VNĐ, 
---gồm: Họ tên, Tên tàu, Số ghế, Giá vé.
create view vw_HighValueTickets as
select p.passenger_full_name, t.train_name, tk.seat_number, tk.ticket_price
from Passengers p, Trains t, Tickets tk
where p.passenger_id = tk.passenger_id and tk.train_id = t.train_id and tk.ticket_price > 500000;

-------PHẦN 4: TẠO TRIGGER-------

---17.Tạo trigger tg_check_ticket_date kiểm tra khi chèn vào bảng Tickets. Nếu ngày khởi hành 
---nhỏ hơn ngày hiện tại thì báo lỗi "Ngày khởi hành không hợp lệ" và hủy thao tác.
create or replace function check_ticket_date() 
returns trigger as $$
begin
    if new.departure_date < current_date then
        raise exception 'Ngày khởi hành không hợp lệ';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger tg_check_ticket_date
before insert on Tickets
for each row
execute function check_ticket_date();

---18.Tạo trigger tg_update_seats tự động giảm total_seats của bảng Trains đi 1 
---khi có một bản ghi mới được thêm vào bảng Tickets.
create or replace function update_seats()
returns trigger as $$
begin
    update Trains
    set total_seats = total_seats-1
    where train_id = new.train_id;

    return new;
end;
$$ language plpgsql;

create trigger tg_update_seats
after insert on Tickets
for each row
execute function update_seats();

-------PHẦN 4: TẠO STORED PROCEDURE-------

---19.Viết Procedure sp_add_passenger để thêm mới một hành khách.---
create or replace procedure sp_add_passenger(
    p_passenger_id varchar(5),
    p_passenger_full_name varchar(100),
    p_passenger_email varchar(100),
    p_passenger_phone varchar(15),
    p_passenger_cccd varchar(20)
) as $$
begin
    insert into Passengers(passenger_id, passenger_full_name, passenger_email, passenger_phone, passenger_cccd)
    values (p_passenger_id, p_passenger_full_name, p_passenger_email, p_passenger_phone, p_passenger_cccd);
end;
$$ language plpgsql;

---20.Viết Procedure sp_cancel_ticket nhận vào p_ticket_id, 
---thực hiện xóa vé trong bảng Tickets và các giao dịch liên quan trong bảng Transactions.
create or replace procedure sp_cancel_ticket(p_ticket_id varchar(5)) 
as $$
begin
    delete from Tickets
    where ticket_id = p_ticket_id;

    delete from Transactions
    where ticket_id = p_ticket_id;
end;
$$ language plpgsql;
