ENTRY(_start)

SECTIONS
{
	.boot : {
		*(.boot .boot.*)
	}

	.text : {
		*(.text .text.*)
	}
}
