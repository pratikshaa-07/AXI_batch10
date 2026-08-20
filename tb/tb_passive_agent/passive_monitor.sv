
class passive_monitor extends uvm_monitor;
  `uvm_component_utils(passive_monitor)
 
  virtual inf.MON vif;
  uvm_analysis_port #(seq_item) send_port;
 
  seq_item tr;
 
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    send_port = new("send_port", this);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
      `uvm_fatal("PASS_MON", "Unable to access Interface");
  endfunction
 
  task run_phase(uvm_phase phase);
    repeat(3) @(vif.mon_cb);
    forever begin
      tr = seq_item::type_id::create("tr");
      tr.rd_en   = vif.mon_cb.rd_en;
      tr.rd_data = vif.mon_cb.rd_data;
      `uvm_info("RD_MON",$sformatf("rd_en=%0d rd_data=%0d",tr.rd_en,tr.rd_data),UVM_LOW)
      send_port.write(tr);
      repeat(2)@(vif.mon_cb);
    end
  endtask
 
endclass
