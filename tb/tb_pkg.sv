//--------------------------------------------------------------------------------------------
// Package: cpu_tb_pkg
// NEW FILE. Bundles every tb/ class into one package, in dependency order,
// matching the vendor's own axi4_master_pkg.sv / axi4_slave_pkg.sv convention.
// Needs axi4_globals_pkg and axi4_slave_pkg compiled/imported before this.
//--------------------------------------------------------------------------------------------
package cpu_tb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import axi4_globals_pkg::*;
  import axi4_slave_pkg::*;

  // ADDED: axi4_slave_write_seq/axi4_slave_read_seq (copied into tb/slave_seq -
  // see the note at the top of tb/slave_seq/axi4_slave_base_seq.sv for why).
  // Only need axi4_slave_tx/axi4_slave_pkg types, both already imported above.
  `include "slave_seq/axi4_slave_base_seq.sv"
  `include "slave_seq/axi4_slave_write_seq.sv"
  `include "slave_seq/axi4_slave_read_seq.sv"

  `include "tb_active_agent/seq_item.sv"
  `include "tb_active_agent/sequencer.sv"
  `include "tb_active_agent/driver.sv"
  `include "tb_active_agent/active_monitor.sv"
  `include "cpu_agent/active_agent.sv"
  `include "cpu_agent/write_seq.sv"
  `include "cpu_agent/read_seq.sv"   // ADDED: cpu-side read sequence

  `include "tb_passive_agent/passive_agent.sv"
  `include "tb_passive_agent/passive_monitor.sv"

  `include "env/scoreboard.sv"
  `include "env/environment.sv"
  `include "env/axi_vip_env.sv"

  `include "vseq/top_vseq.sv"
  // ADDED: the 2 virtual sequences that run the cpu sequence and the AXI4
  // slave sequence together (see each file's header comment for why).
  `include "vseq/axi4_virtual_write_seq.sv"
  `include "vseq/axi4_virtual_read_seq.sv"

  `include "env/top_env.sv"
  `include "test/base_test.sv"
  `include "test/single_seq_test.sv"
  // ADDED: the 2 requested virtual testcases.
  `include "test/axi4_virtual_write_test.sv"
  `include "test/axi4_virtual_read_test.sv"

endpackage : cpu_tb_pkg
